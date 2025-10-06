#!/bin/bash
# Helper script to start Jupyter Lab for VS Code connection
# For use with Scientific Computing 2025 course

set -e

IMAGE="ghcr.io/paulgribble/scicomp:2025"
CONTAINER_NAME="scicomp"
PORT="8888"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Scientific Computing 2025 - Jupyter Lab Starter${NC}"
echo "=================================================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker is not running!${NC}"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

# Check if container is already running
if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo -e "${YELLOW}Container '${CONTAINER_NAME}' is already running.${NC}"
    echo "Stop it first with: docker stop ${CONTAINER_NAME}"
    exit 1
fi

# Check if image exists locally
if ! docker image inspect ${IMAGE} > /dev/null 2>&1; then
    echo -e "${YELLOW}Image not found locally. Pulling from registry...${NC}"
    docker pull ${IMAGE}
    echo ""
fi

echo -e "${GREEN}Starting Jupyter Lab server...${NC}"
echo "Your current directory will be mounted as /home/student/work"
echo ""
echo -e "${YELLOW}INSTRUCTIONS:${NC}"
echo "1. Wait for Jupyter to start (watch for the URL below)"
echo "2. Copy the ENTIRE URL that looks like:"
echo "   http://127.0.0.1:8888/lab?token=abc123..."
echo "3. In VS Code:"
echo "   - Open a .ipynb file"
echo "   - Click 'Select Kernel' (top-right)"
echo "   - Choose 'Existing Jupyter Server'"
echo "   - Paste the URL"
echo "4. Press Ctrl+C here to stop the server when done"
echo ""
echo "=================================================="
echo ""

# Start the container
docker run --rm -it \
  --name ${CONTAINER_NAME} \
  -p ${PORT}:8888 \
  -v "$PWD:/home/student/work" \
  ${IMAGE} \
  jupyter lab --ip=0.0.0.0 --no-browser
