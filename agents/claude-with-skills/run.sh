#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_ROOT="$SCRIPT_DIR/skills"

# -----[ STEP 1 ]-----
# Extract the enivronement vairables that are assumed to have been set
WORK_DIR="${SCARF_WORK_DIR:-${SCARF_WORKDIR:-}}" # As a defensive step, we select either SCARF_WORK_DIR or SCARF_WORKDIR
FRAMEWORK_FROM="${SCARF_FRAMEWORK_FROM:-${SCARF_FROM_FRAMEWORK:-}}"
FRAMEWORK_TO="${SCARF_FRAMEWORK_TO:-${SCARF_TO_FRAMEWORK:-}}"


# -----[ STEP 2 ]-----
# Ensure these vairables are correctly set
if [[ -z "$WORK_DIR" || -z "$FRAMEWORK_FROM" || -z "$FRAMEWORK_TO" ]]; then
  echo "Error: require SCARF_WORK_DIR (or SCARF_WORKDIR), SCARF_FRAMEWORK_FROM (or SCARF_FROM_FRAMEWORK), and SCARF_FRAMEWORK_TO (or SCARF_TO_FRAMEWORK)." >&2
  exit 1
fi

# -----[ STEP 3 ]-----
# Ensure that the workdir exists
if [[ ! -d "$WORK_DIR" ]]; then
  echo "Error: SCARF work directory does not exist: $WORK_DIR" >&2
  exit 1
fi

# -----[ STEP 4 ]-----
# Generate unique identifiers for this run to avoid Docker conflicts
RUN_ID="scarf_$(date +%s)_$$"
CONTAINER_NAME="${RUN_ID}_app"
IMAGE_TAG="${RUN_ID}:latest"

# Export these for the agent to use in Docker operations
export SCARF_RUN_ID="$RUN_ID"
export SCARF_CONTAINER_NAME="$CONTAINER_NAME"
export SCARF_IMAGE_TAG="$IMAGE_TAG"
export SCARF_DOCKER_PORT="0"  # Use dynamic port allocation

echo "[INFO] Docker isolation enabled"
echo "[INFO] Run ID: $RUN_ID"
echo "[INFO] Container name: $CONTAINER_NAME"
echo "[INFO] Image tag: $IMAGE_TAG"

# Normalize the framework name
norm_framework() {
  local raw
  raw="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
  case "$raw" in
    spring|springboot|spring-framework) echo "spring" ;;
    quarkus) echo "quarkus" ;;
    jakarta|jakartaee|jakartaee10) echo "jakarta" ;;
    *)
      echo "Error: unsupported framework '$1' (normalized: '$raw'). Expected spring, quarkus, or jakarta." >&2
      exit 1
      ;;
  esac
}

FROM_NORMALIZED="$(norm_framework "$FRAMEWORK_FROM")"
TO_NORMALIZED="$(norm_framework "$FRAMEWORK_TO")"
PAIR="${FROM_NORMALIZED}-to-${TO_NORMALIZED}"
PAIR_ROOT=""
PAIR_SKILL_DIR=""

# Support both layouts:
# 1) skills/<pair>/SKILL.md
if [[ -f "$SKILLS_ROOT/${PAIR}/SKILL.md" ]]; then
  PAIR_ROOT="$SKILLS_ROOT"
  PAIR_SKILL_DIR="$SKILLS_ROOT/${PAIR}"
else
  echo "Error: missing skill bundle for '$PAIR' under '$SKILLS_ROOT'." >&2
  exit 1
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "Error: 'claude' CLI not found in PATH." >&2
  exit 1
fi

MANAGED_ROOT="$WORK_DIR/.agent"
MANAGED_SKILLS_LINK="$MANAGED_ROOT/skills"
MANAGED_AGENTS="$WORK_DIR/CLAUDE.md"
MANAGED_AGENTS_BACKUP=""

# Cleanup function to remove Docker artifacts and agent files
cleanup() {
  set +e
  
  # Clean up Docker resources
  echo "[INFO] Cleaning up Docker resources for run: $RUN_ID"
  
  # Stop and remove any containers with our run ID
  docker ps -a --filter "name=${RUN_ID}" --format "{{.Names}}" 2>/dev/null | while read -r container; do
    echo "[INFO] Stopping container: $container"
    docker stop "$container" 2>/dev/null || true
    echo "[INFO] Removing container: $container"
    docker rm "$container" 2>/dev/null || true
  done
  
  # Remove images with our run ID tag
  docker images --filter "reference=*${RUN_ID}*" --format "{{.Repository}}:{{.Tag}}" 2>/dev/null | while read -r image; do
    echo "[INFO] Removing image: $image"
    docker rmi "$image" 2>/dev/null || true
  done
  
  # Clean up dangling images from this build
  docker image prune -f 2>/dev/null || true
  
  # Clean up agent files
  if [[ -n "$MANAGED_AGENTS_BACKUP" && -f "$MANAGED_AGENTS_BACKUP" ]]; then
    mv -f "$MANAGED_AGENTS_BACKUP" "$MANAGED_AGENTS"
  else
    rm -f "$MANAGED_AGENTS"
  fi
  rm -f "$MANAGED_SKILLS_LINK"
  rmdir "$MANAGED_ROOT" >/dev/null 2>&1 || true
}
trap cleanup EXIT

mkdir -p "$MANAGED_ROOT"
ln -sfn "$PAIR_SKILL_DIR" "$MANAGED_SKILLS_LINK"

if [[ -e "$MANAGED_AGENTS" ]]; then
  MANAGED_AGENTS_BACKUP="$WORK_DIR/.scarfbench-agent.CLAUDE.backup.$$"
  mv "$MANAGED_AGENTS" "$MANAGED_AGENTS_BACKUP"
fi

cat > "$MANAGED_AGENTS" <<EOT
# CLAUDE.md

## Skills
A skill is a set of local instructions stored in a \`SKILL.md\` file.

### Available skills
- ${PAIR}: Framework migration skill for ${FROM_NORMALIZED} -> ${TO_NORMALIZED}. (file: ${MANAGED_SKILLS_LINK}/SKILL.md)

### How to use skills
- Trigger rules: for framework migration requests, use the matching \`*-to-*\` skill.
- If either side is Jakarta, assume OpenLiberty.
- If source/target is ambiguous, ask one clarifying question.
EOT

PROMPT="Migrate this Java project from ${FROM_NORMALIZED} to ${TO_NORMALIZED}. Execute fully in one run using the available local migration skill. Operate only inside the current working directory, preserve behavior, attempt compilation, and document actions/errors in CHANGELOG.md.

CRITICAL: For Docker operations, you MUST use these environment variables to avoid conflicts with parallel runs:
- Container name: \$SCARF_CONTAINER_NAME (currently: $CONTAINER_NAME)
- Image tag: \$SCARF_IMAGE_TAG (currently: $IMAGE_TAG)
- Port mapping: Use '-p 0:8080' for dynamic port allocation

Example Docker commands:
  docker build -t \$SCARF_IMAGE_TAG .
  docker run -d --name \$SCARF_CONTAINER_NAME -p 0:8080 \$SCARF_IMAGE_TAG
  ASSIGNED_PORT=\$(docker port \$SCARF_CONTAINER_NAME 8080 | cut -d: -f2)
  curl http://localhost:\$ASSIGNED_PORT/health

The wrapper script will automatically clean up Docker resources after execution."

echo "Running Claude Code headless for pair: $PAIR"
echo "Work dir: $WORK_DIR"
echo "Skill symlink: $MANAGED_SKILLS_LINK -> $PAIR_SKILL_DIR"

cd "$WORK_DIR"
claude -p "$PROMPT" --output-format text --verbose
