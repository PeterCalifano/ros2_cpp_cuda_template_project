#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common_core_profiler.sh
source "${SCRIPT_DIR}/common_core_profiler.sh"

parse_common_args "$@"
resolve_core_executable
reject_ros2_target_by_default
prepare_output_dir

if command -v valgrind >/dev/null 2>&1; then
  print_or_run valgrind --tool=massif --massif-out-file="${output_dir}/massif.out.%p" "$executable" "${args[@]}"
else
  echo "valgrind not found; running benchmark directly." >&2
  print_or_run "$executable" "${args[@]}"
fi

