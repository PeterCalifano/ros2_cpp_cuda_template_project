#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
This helper is intentionally separate from core profiling.

Use it for ROS2 graph integration timing only: launch startup, lifecycle
transition latency, service round-trip latency, executor behavior, and DDS
overhead. Do not use this script to claim core-library algorithm performance.
EOF

