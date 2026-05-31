#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-template-project-dev}"
ROS_DOMAIN_ID="${ROS_DOMAIN_ID:-42}"
GPU_ARGS=()

if command -v nvidia-smi >/dev/null 2>&1; then
  GPU_ARGS=(--gpus all)
fi

docker build -f "${ROOT_DIR}/docker/Dockerfile" --target dev -t "$IMAGE_NAME" "$ROOT_DIR"
docker run --rm -it \
  --network host \
  -e ROS_DOMAIN_ID="$ROS_DOMAIN_ID" \
  "${GPU_ARGS[@]}" \
  -v "${ROOT_DIR}:/workspace" \
  "$IMAGE_NAME" \
  bash

