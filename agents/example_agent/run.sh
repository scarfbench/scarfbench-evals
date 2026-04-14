#!/usr/bin/env bash
# Invoke your coding agent CLI to migrate a Java app from SCARF_FROM_FRAMEWORK to SCARF_TO_FRAMEWORK.
# SCARF_WORKDIR = absolute path to the application (Java project) root.
# Reads prompt from prompt.txt and substitutes {{ VAR }} with env var values.

set -e

if [[ -z "${SCARF_WORKDIR}" || -z "${SCARF_FROM_FRAMEWORK}" || -z "${SCARF_TO_FRAMEWORK}" ]]; then
  echo "Error: SCARF_WORKDIR, SCARF_FROM_FRAMEWORK, and SCARF_TO_FRAMEWORK must be set." >&2
  exit 1
fi

PROMPT_FILE="prompt.txt"

# Read prompt and substitute {{ VAR }} with env var values
PROMPT=$(cat "$PROMPT_FILE")
for var in $(grep -oE '\{\{\s*[A-Za-z_][A-Za-z0-9_]*\s*\}\}' "$PROMPT_FILE" | sed 's/[{} ]//g' | sort -u); do
  val="${!var}"
  [[ -n "$val" ]] && PROMPT="${PROMPT//\{\{ $var \}\}/$val}"
done

cd "$SCARF_WORKDIR"

echo "=== Prompt ==="
echo "$PROMPT"
echo "=============="

# Replace the line below with your agent CLI invocation, e.g.:
#   claude -p "$PROMPT" --output-format text --verbose
#   codex exec "$PROMPT" --skip-git-repo-check --sandbox danger-full-access -C "$SCARF_WORKDIR"
#   gemini -p "$PROMPT"
your-agent-cli "$PROMPT"
