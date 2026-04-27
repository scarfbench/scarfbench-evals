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

cleanup() {
  set +e
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

PROMPT="Migrate this Java project from ${FROM_NORMALIZED} to ${TO_NORMALIZED}. Execute fully in one run using the available local migration skill. Operate only inside the current working directory, preserve behavior, attempt compilation, and document actions/errors in CHANGELOG.md."

echo "Running Claude Code headless for pair: $PAIR"
echo "Work dir: $WORK_DIR"
echo "Skill symlink: $MANAGED_SKILLS_LINK -> $PAIR_SKILL_DIR"

cd "$WORK_DIR"
claude \
  --model aws/claude-opus-4-6 \
  --output-format stream-json \
  --print \
  --verbose \
  --tools default \
  --add-dir "$WORK_DIR" \
  --permission-mode bypassPermissions \
  "$PROMPT"
