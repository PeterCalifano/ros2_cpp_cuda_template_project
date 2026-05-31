#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEFAULT_BUILD_EXE="${ROOT_DIR}/ros2_ws/build/template_project_core/template_project_core_benchmark"
DEFAULT_INSTALL_EXE="${ROOT_DIR}/ros2_ws/install/template_project_core/lib/template_project_core/template_project_core_benchmark"

dry_run=false
allow_ros2_target=false
output_dir="${ROOT_DIR}/prof_results"
executable=""
args=("100000")

common_usage() {
  cat <<'EOF'
Common options:
  -e, --exe <path>          Core benchmark executable.
  -o, --output <dir>        Output directory (default: prof_results).
      --allow-ros2-target   Permit profiling a ROS2 executable. Off by default.
      --dry-run             Print resolved command without executing it.
      --args <args...>      Arguments passed to the executable; must be last.
EOF
}

parse_common_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -e|--exe)
        executable="${2:?--exe requires a path}"
        shift 2
        ;;
      -o|--output)
        output_dir="${2:?--output requires a directory}"
        shift 2
        ;;
      --allow-ros2-target)
        allow_ros2_target=true
        shift
        ;;
      --dry-run)
        dry_run=true
        shift
        ;;
      --args)
        shift
        args=("$@")
        break
        ;;
      -h|--help)
        common_usage
        exit 0
        ;;
      *)
        echo "Unknown option: $1" >&2
        common_usage >&2
        exit 2
        ;;
    esac
  done
}

resolve_core_executable() {
  if [[ -n "$executable" ]]; then
    return
  fi
  if [[ -x "$DEFAULT_BUILD_EXE" ]]; then
    executable="$DEFAULT_BUILD_EXE"
  elif [[ -x "$DEFAULT_INSTALL_EXE" ]]; then
    executable="$DEFAULT_INSTALL_EXE"
  else
    echo "Core benchmark executable not found. Build template_project_core first." >&2
    echo "Checked: $DEFAULT_BUILD_EXE" >&2
    echo "Checked: $DEFAULT_INSTALL_EXE" >&2
    exit 1
  fi
}

reject_ros2_target_by_default() {
  if [[ "$allow_ros2_target" == true ]]; then
    return
  fi

  local exe_base
  exe_base="$(basename "$executable")"
  case "$executable:$exe_base" in
    *template_project_nodes*|*rclcpp_components*|*component_container*|*ros2\ launch*|*launch*|*node*)
      echo "Refusing to profile a ROS2-facing executable by default: $executable" >&2
      echo "Use --allow-ros2-target only for explicit integration timing work." >&2
      exit 3
      ;;
  esac
}

prepare_output_dir() {
  mkdir -p "$output_dir"
}

print_or_run() {
  if [[ "$dry_run" == true ]]; then
    printf 'Resolved command:'
    printf ' %q' "$@"
    printf '\n'
    return
  fi
  "$@"
}
