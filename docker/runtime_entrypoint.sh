#!/usr/bin/env bash
set -e

if [[ -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]]; then
  # shellcheck disable=SC1090
  source "/opt/ros/${ROS_DISTRO}/setup.bash"
fi
if [[ -f "/workspace/install/setup.bash" ]]; then
  # shellcheck disable=SC1091
  source "/workspace/install/setup.bash"
fi

exec "$@"

