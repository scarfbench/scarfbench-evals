#!/usr/bin/env bash
set -euo pipefail

# Resolve agent bin directory
AGENT_BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Environment variables set by scarf CLI:
# - ${SCARF_WORK_DIR}       -> Work directory for agent outputs
# - ${SCARF_FRAMEWORK_TO}   -> Target framework
# - ${SCARF_FRAMEWORK_FROM} -> Source framework

echo "Bob Migration Agent"
echo "==================="
echo "Work Directory: ${SCARF_WORK_DIR}"
echo "Framework From: ${SCARF_FRAMEWORK_FROM}"
echo "Framework To: ${SCARF_FRAMEWORK_TO}"
echo ""

# Check if Bob CLI is installed
if ! command -v bob &> /dev/null; then
    echo "ERROR: Bob CLI is not installed."
    echo "Please install Bob CLI using one of the following methods:"
    echo ""
    echo "1. Using Bob Command Palette:"
    echo "   - Press Ctrl+Shift+P (Windows/Linux) or Cmd+Shift+P (macOS)"
    echo "   - Type and select: run bobshell"
    echo ""
    echo "2. Using terminal command:"
    echo "   curl -s https://s3.us-south.cloud-object-storage.appdomain.cloud/bobshell/install-bobshell.sh | bash"
    echo ""
    exit 1
fi

# Check if required Bob CLI environment variables are set
if [ -z "${BOBSHELL_API_KEY:-}" ]; then
    echo "ERROR: BOBSHELL_API_KEY environment variable is not set."
    echo "Please set it before running this agent:"
    echo "  export BOBSHELL_API_KEY=your_api_key"
    exit 1
fi

# Read prompt template and substitute framework variables
PROMPT_TEMPLATE="${AGENT_BIN}/prompt.txt"

if [ ! -f "${PROMPT_TEMPLATE}" ]; then
    echo "ERROR: prompt.txt not found at ${PROMPT_TEMPLATE}"
    exit 1
fi

# Substitute template variables
MIGRATION_PROMPT=$(cat "${PROMPT_TEMPLATE}" | \
    sed "s/{{ before }}/${SCARF_FRAMEWORK_FROM}/g" | \
    sed "s/{{ after }}/${SCARF_FRAMEWORK_TO}/g")

# Change to work directory
cd "${SCARF_WORK_DIR}"

echo "Running Bob CLI migration..."
echo ""

# Execute Bob CLI with migration prompt
# Bob CLI will analyze files in the current directory and make changes
bob -p "${MIGRATION_PROMPT}"

# Check if Bob CLI succeeded
if [ $? -eq 0 ]; then
    echo ""
    echo "Migration completed successfully!"
    exit 0
else
    echo ""
    echo "ERROR: Migration failed!"
    exit 1
fi