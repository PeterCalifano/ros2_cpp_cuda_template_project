#!/usr/bin/env bash
set -euo pipefail

ros2 launch template_project_bringup template_project.launch.py "$@"

