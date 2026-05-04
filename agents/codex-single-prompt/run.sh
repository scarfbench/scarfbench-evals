#!/usr/bin/env bash
set -euo pipefail

# Resolve agent directory (where this script lives)
AGENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read environment variables set by scarf
WORK_DIR="${SCARF_WORK_DIR:-}"
FRAMEWORK_FROM="${SCARF_FRAMEWORK_FROM:-}"
FRAMEWORK_TO="${SCARF_FRAMEWORK_TO:-}"

# Validate required environment variables
if [[ -z "$WORK_DIR" ]]; then
    echo "[ERROR] SCARF_WORK_DIR environment variable is not set" >&2
    exit 1
fi

if [[ -z "$FRAMEWORK_FROM" ]]; then
    echo "[ERROR] SCARF_FRAMEWORK_FROM environment variable is not set" >&2
    exit 1
fi

if [[ -z "$FRAMEWORK_TO" ]]; then
    echo "[ERROR] SCARF_FRAMEWORK_TO environment variable is not set" >&2
    exit 1
fi

# Check if CHANGELOG.md already exists (skip if already completed)
if [[ -f "$WORK_DIR/CHANGELOG.md" ]]; then
    echo "[INFO] CHANGELOG.md already exists in $WORK_DIR" >&2
    echo "[INFO] Skipping this run (already completed)" >&2
    exit 0
fi

# Generate unique identifiers for this run to avoid conflicts
RUN_ID="scarf_$(date +%s)_$$"
CONTAINER_NAME="${RUN_ID}_app"
IMAGE_TAG="${RUN_ID}:latest"

# Export these for Codex to use
export SCARF_RUN_ID="$RUN_ID"
export SCARF_CONTAINER_NAME="$CONTAINER_NAME"
export SCARF_IMAGE_TAG="$IMAGE_TAG"
export SCARF_DOCKER_PORT="0"  # Use dynamic port allocation

# Cleanup function to remove Docker artifacts
cleanup_docker() {
    echo "[INFO] Cleaning up Docker resources for run: $RUN_ID"
    
    # Stop and remove any containers with our run ID
    docker ps -a --filter "name=${RUN_ID}" --format "{{.Names}}" | while read -r container; do
        echo "[INFO] Stopping container: $container"
        docker stop "$container" 2>/dev/null || true
        echo "[INFO] Removing container: $container"
        docker rm "$container" 2>/dev/null || true
    done
    
    # Remove images with our run ID tag
    docker images --filter "reference=*${RUN_ID}*" --format "{{.Repository}}:{{.Tag}}" | while read -r image; do
        echo "[INFO] Removing image: $image"
        docker rmi "$image" 2>/dev/null || true
    done
    
    # Clean up dangling images from this build
    docker image prune -f 2>/dev/null || true
}

# Register cleanup to run on exit (success or failure)
trap cleanup_docker EXIT

# Read the prompt template 
PROMPT_TEMPLATE="$AGENT_DIR/prompt.txt"
if [[ ! -f "$PROMPT_TEMPLATE" ]]; then
    echo "[ERROR] Prompt template not found at: $PROMPT_TEMPLATE" >&2
    exit 1
fi

# Replace template variables in the prompt
PROMPT=$(cat "$PROMPT_TEMPLATE" | sed "s/{{ before }}/$FRAMEWORK_FROM/g" | sed "s/{{ after }}/$FRAMEWORK_TO/g")

echo "[INFO] Starting Codex migration agent"
echo "[INFO] Working directory: $WORK_DIR"
echo "[INFO] Migration: $FRAMEWORK_FROM -> $FRAMEWORK_TO"
echo "[INFO] Run ID: $RUN_ID"
echo "[INFO] Container name: $CONTAINER_NAME"
echo "[INFO] Image tag: $IMAGE_TAG"

# Change to working directory and invoke Codex CLI
cd "$WORK_DIR"

# Run Codex with the specified parameters
codex exec \
  "$PROMPT" \
  --skip-git-repo-check \
  --sandbox danger-full-access \
  --json \
  -C "$WORK_DIR" 

EXIT_CODE=$?

if [[ $EXIT_CODE -eq 0 ]]; then
    echo "[INFO] Codex agent completed successfully"
else
    echo "[ERROR] Codex agent failed with exit code: $EXIT_CODE" >&2
fi

# Cleanup will run automatically via trap
exit $EXIT_CODE

