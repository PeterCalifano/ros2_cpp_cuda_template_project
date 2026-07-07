#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
apply=false
yes=false
keep_profiling=false
keep_description=false
keep_deployment=false

usage() {
  cat <<'EOF'
Usage: ./tailor_ros2_template_cleanup.sh --list
       ./tailor_ros2_template_cleanup.sh --apply [--yes] [options]

Options:
  --list                 Show files/directories removed by default.
  --apply                Apply cleanup.
  --yes                  Do not prompt before applying.
  --keep-profiling       Keep profiling scripts.
  --keep-description     Keep template_project_description.
  --keep-deployment      Keep docker and devcontainer files.
  -h, --help             Show this help.
EOF
}

mode=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --list)
      mode="list"
      shift
      ;;
    --apply)
      mode="apply"
      apply=true
      shift
      ;;
    --yes)
      yes=true
      shift
      ;;
    --keep-profiling)
      keep_profiling=true
      shift
      ;;
    --keep-description)
      keep_description=true
      shift
      ;;
    --keep-deployment)
      keep_deployment=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$mode" ]]; then
  usage >&2
  exit 2
fi

declare -a removals=(
  "doc/developments"
  "tests/template_checks"
)
if [[ "$keep_profiling" == false ]]; then
  removals+=("profiling")
fi
if [[ "$keep_description" == false ]]; then
  removals+=("ros2_ws/src/template_project_description")
fi
if [[ "$keep_deployment" == false ]]; then
  removals+=("docker" ".devcontainer")
fi

if [[ "$mode" == "list" ]]; then
  printf 'Cleanup would remove:\n'
  for item_ in "${removals[@]}"; do
    printf '  - %s\n' "$item_"
  done
  exit 0
fi

if [[ "$apply" == true && "$yes" == false ]]; then
  printf 'Apply cleanup? [y/N] '
  read -r answer_
  case "$answer_" in
    y|Y|yes|YES) ;;
    *) echo "Cancelled."; exit 1 ;;
  esac
fi

for item_ in "${removals[@]}"; do
  rm -rf "${ROOT_DIR}/${item_}"
done

if [[ "$keep_description" == false && -f "${ROOT_DIR}/ros2_ws/src/template_project_spinup/package.xml" ]]; then
  perl -0pi -e 's/\n  <exec_depend>template_project_description<\/exec_depend>//' \
    "${ROOT_DIR}/ros2_ws/src/template_project_spinup/package.xml"
fi

echo "ROS2 template cleanup complete."

