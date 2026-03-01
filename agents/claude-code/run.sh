#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

# -----[ STEP 1 ]-----
# Extract the environment variables that are assumed to have been set
WORK_DIR="${SCARF_WORK_DIR:-${SCARF_WORKDIR:-}}"
FRAMEWORK_FROM="${SCARF_SOURCE_FRAMEWORK:-${SCARF_FRAMEWORK_FROM:-${SCARF_FROM_FRAMEWORK:-}}}"
FRAMEWORK_TO="${SCARF_TARGET_FRAMEWORK:-${SCARF_FRAMEWORK_TO:-${SCARF_TO_FRAMEWORK:-}}}"

# -----[ STEP 2 ]-----
# Ensure these variables are correctly set
if [[ -z "$WORK_DIR" || -z "$FRAMEWORK_FROM" || -z "$FRAMEWORK_TO" ]]; then
  echo "Error: require SCARF_WORK_DIR (or SCARF_WORKDIR), SCARF_SOURCE_FRAMEWORK, and SCARF_TARGET_FRAMEWORK." >&2
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

if ! command -v claude >/dev/null 2>&1; then
  echo "Error: 'claude' CLI not found in PATH." >&2
  exit 1
fi

PROMPT="Migrate this Java project from ${FROM_NORMALIZED} to ${TO_NORMALIZED}. Operate only inside the current working directory, preserve behavior, attempt compilation, and document actions/errors in CHANGELOG.md. Use the available migration skills when relevant."

echo "Running Claude Code headless: ${FROM_NORMALIZED} -> ${TO_NORMALIZED}"
echo "Work dir: $WORK_DIR"

# Copy agent skills into work dir so Claude discovers them (see README.md)
mkdir -p "$WORK_DIR/.claude/skills"
cp -r "$SKILLS_DIR"/* "$WORK_DIR/.claude/skills/" 2>/dev/null || true

cd "$WORK_DIR" && claude -p "$PROMPT" --allowedTools "Read,Edit,Bash"
