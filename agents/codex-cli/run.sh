#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_ROOT="$SCRIPT_DIR/skills"

WORK_DIR="${SCARF_WORK_DIR:-${SCARF_WORKDIR:-}}"
FRAMEWORK_FROM="${SCARF_FRAMEWORK_FROM:-${SCARF_FROM_FRAMEWORK:-}}"
FRAMEWORK_TO="${SCARF_FRAMEWORK_TO:-${SCARF_TO_FRAMEWORK:-}}"

if [[ -z "$WORK_DIR" || -z "$FRAMEWORK_FROM" || -z "$FRAMEWORK_TO" ]]; then
  echo "Error: require SCARF_WORK_DIR (or SCARF_WORKDIR), SCARF_FRAMEWORK_FROM (or SCARF_FROM_FRAMEWORK), and SCARF_FRAMEWORK_TO (or SCARF_TO_FRAMEWORK)." >&2
  exit 1
fi

if [[ ! -d "$WORK_DIR" ]]; then
  echo "Error: SCARF work directory does not exist: $WORK_DIR" >&2
  exit 1
fi

norm_framework() {
  local raw
  raw="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
  case "$raw" in
    spring|springboot|spring-framework) echo "spring" ;;
    quarkus) echo "quarkus" ;;
    jakarta|jakartaee|jakartaee10|jakartaeex) echo "jakarta" ;;
    *)
      echo "Error: unsupported framework '$1' (normalized: '$raw'). Expected spring, quarkus, or jakarta." >&2
      exit 1
      ;;
  esac
}

FROM_NORM="$(norm_framework "$FRAMEWORK_FROM")"
TO_NORM="$(norm_framework "$FRAMEWORK_TO")"
PAIR="${FROM_NORM}-to-${TO_NORM}"
PAIR_ROOT="$SKILLS_ROOT/skills-${PAIR}"
PAIR_SKILL_DIR="$PAIR_ROOT/skills/$PAIR"

if [[ ! -f "$PAIR_ROOT/AGENTS.md" || ! -f "$PAIR_SKILL_DIR/SKILL.md" ]]; then
  echo "Error: missing skill bundle for '$PAIR' at '$PAIR_ROOT'." >&2
  exit 1
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "Error: 'codex' CLI not found in PATH." >&2
  exit 1
fi

MANAGED_ROOT="$WORK_DIR/.scarfbench-agent"
MANAGED_SKILLS_LINK="$MANAGED_ROOT/skills"
MANAGED_AGENTS="$WORK_DIR/AGENTS.md"
MANAGED_AGENTS_BACKUP=""

cleanup() {
  set +e
  if [[ -n "$MANAGED_AGENTS_BACKUP" && -f "$MANAGED_AGENTS_BACKUP" ]]; then
    mv -f "$MANAGED_AGENTS_BACKUP" "$MANAGED_AGENTS"
  else
    rm -f "$MANAGED_AGENTS"
  fi
}
trap cleanup EXIT

mkdir -p "$MANAGED_ROOT"
ln -sfn "$PAIR_SKILL_DIR" "$MANAGED_SKILLS_LINK"

if [[ -e "$MANAGED_AGENTS" ]]; then
  MANAGED_AGENTS_BACKUP="$WORK_DIR/.scarfbench-agent.AGENTS.backup.$$"
  mv "$MANAGED_AGENTS" "$MANAGED_AGENTS_BACKUP"
fi

cat > "$MANAGED_AGENTS" <<EOF
# AGENTS.md

## Skills
A skill is a set of local instructions stored in a \`SKILL.md\` file.

### Available skills
- ${PAIR}: Framework migration skill for ${FROM_NORM} -> ${TO_NORM}. (file: ${MANAGED_SKILLS_LINK}/SKILL.md)

### How to use skills
- Trigger rules: for framework migration requests, use the matching \`*-to-*\` skill.
- If either side is Jakarta, assume OpenLiberty.
- If source/target is ambiguous, ask one clarifying question.
EOF

PROMPT="Migrate this Java project from ${FROM_NORM} to ${TO_NORM}. Execute fully in one run using the available local migration skill. Operate only inside the current working directory, preserve behavior, attempt compilation, and document actions/errors in CHANGELOG.md."

echo "Running Codex headless for pair: $PAIR"
echo "Work dir: $WORK_DIR"
echo "Skill symlink: $MANAGED_SKILLS_LINK -> $PAIR_SKILL_DIR"

codex -a never exec \
  --sandbox workspace-write \
  --skip-git-repo-check \
  -C "$WORK_DIR" \
  "$PROMPT"
