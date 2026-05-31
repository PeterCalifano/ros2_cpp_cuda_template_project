#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-template-project-runtime}"
ROS_DOMAIN_ID="${ROS_DOMAIN_ID:-42}"

docker build -f "${ROOT_DIR}/docker/Dockerfile" --target runtime -t "$IMAGE_NAME" "$ROOT_DIR"
docker run --rm -it \
  --network host \
  -e ROS_DOMAIN_ID="$ROS_DOMAIN_ID" \
  "$IMAGE_NAME" \
  "$@"

