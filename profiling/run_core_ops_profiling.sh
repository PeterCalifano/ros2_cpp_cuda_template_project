#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common_core_profiler.sh
source "${SCRIPT_DIR}/common_core_profiler.sh"

parse_common_args "$@"
resolve_core_executable
reject_ros2_target_by_default
prepare_output_dir

if command -v perf >/dev/null 2>&1; then
  print_or_run perf stat -o "${output_dir}/perf-stat.txt" "$executable" "${args[@]}"
else
  echo "perf not found; using /usr/bin/time when available." >&2
  if [[ -x /usr/bin/time ]]; then
    print_or_run /usr/bin/time -v "$executable" "${args[@]}"
  else
    print_or_run "$executable" "${args[@]}"
  fi
fi

