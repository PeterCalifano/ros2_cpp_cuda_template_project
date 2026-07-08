#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="${ROOT_DIR}/ros2_ws"
ROS_DISTRO_DEFAULT="${ROS_DISTRO:-jazzy}"

build_type="RelWithDebInfo"
clean=false
skip_tests=false
enable_cuda=false
enable_optix=false
profile_core=false
packages_select=()
cmake_args=()
colcon_args=()

usage() {
  cat <<'EOF'
Usage: ./build_ros2_ws.sh [options]

Options:
  --clean                         Remove ros2_ws/build, install, and log before building.
  --debug                         Use CMAKE_BUILD_TYPE=Debug.
  --release                       Use CMAKE_BUILD_TYPE=Release.
  --relwithdebinfo                Use CMAKE_BUILD_TYPE=RelWithDebInfo (default).
  --build-type <type>             Use an explicit CMake build type.
  --packages-select <pkg...>      Build/test selected packages.
  --skip-tests                    Skip colcon test.
  --cuda                          Enable core CUDA support.
  --optix                         Enable core OptiX support; implies CUDA.
  --profile-core                  Enable profiler-friendly flags for template_project_core only.
  --cmake-arg <arg>               Append one CMake argument. Repeatable.
  --colcon-arg <arg>              Append one colcon build argument. Repeatable.
  -h, --help                      Show this help.

Examples:
  ./build_ros2_ws.sh --clean
  ./build_ros2_ws.sh --packages-select template_project_core
  ./build_ros2_ws.sh --cuda --cmake-arg -DCUDA_ARCHITECTURES=87
  ./build_ros2_ws.sh --profile-core --packages-select template_project_core
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --clean)
      clean=true
      shift
      ;;
    --debug)
      build_type="Debug"
      shift
      ;;
    --release)
      build_type="Release"
      shift
      ;;
    --relwithdebinfo)
      build_type="RelWithDebInfo"
      shift
      ;;
    --build-type)
      build_type="${2:?--build-type requires a value}"
      shift 2
      ;;
    --packages-select)
      shift
      while [[ $# -gt 0 && "$1" != --* ]]; do
        packages_select+=("$1")
        shift
      done
      ;;
    --skip-tests)
      skip_tests=true
      shift
      ;;
    --cuda)
      enable_cuda=true
      shift
      ;;
    --optix)
      enable_optix=true
      enable_cuda=true
      shift
      ;;
    --profile-core)
      profile_core=true
      shift
      ;;
    --cmake-arg)
      cmake_args+=("${2:?--cmake-arg requires a value}")
      shift 2
      ;;
    --colcon-arg)
      colcon_args+=("${2:?--colcon-arg requires a value}")
      shift 2
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

setup_file="/opt/ros/${ROS_DISTRO_DEFAULT}/setup.bash"
if [[ -f "$setup_file" ]]; then
  set +u
  # shellcheck source=/dev/null
  source "$setup_file"
  set -u
else
  echo "ROS setup file not found: $setup_file" >&2
  echo "Set ROS_DISTRO or install/source ROS2 before running this script." >&2
  exit 1
fi

if [[ "$clean" == true ]]; then
  rm -rf "${WORKSPACE_DIR}/build" "${WORKSPACE_DIR}/install" "${WORKSPACE_DIR}/log"
fi

base_cmake_args=(
  "-DCMAKE_BUILD_TYPE=${build_type}"
  "-DTEMPLATE_PROJECT_ENABLE_CUDA=$([[ "$enable_cuda" == true ]] && echo ON || echo OFF)"
  "-DTEMPLATE_PROJECT_ENABLE_OPTIX=$([[ "$enable_optix" == true ]] && echo ON || echo OFF)"
  "-DTEMPLATE_PROJECT_PROFILE_CORE=$([[ "$profile_core" == true ]] && echo ON || echo OFF)"
)

build_cmd=(colcon build --symlink-install --cmake-args "${base_cmake_args[@]}" "${cmake_args[@]}")
if [[ ${#packages_select[@]} -gt 0 ]]; then
  build_cmd+=(--packages-select "${packages_select[@]}")
fi
if [[ ${#colcon_args[@]} -gt 0 ]]; then
  build_cmd+=("${colcon_args[@]}")
fi

echo "Workspace    : ${WORKSPACE_DIR}"
echo "Build type   : ${build_type}"
echo "CUDA         : ${enable_cuda}"
echo "OptiX        : ${enable_optix}"
echo "Profile core : ${profile_core}"
(
  cd "$WORKSPACE_DIR"
  "${build_cmd[@]}"
)

if [[ "$skip_tests" == false ]]; then
  test_cmd=(colcon test --event-handlers console_direct+)
  if [[ ${#packages_select[@]} -gt 0 ]]; then
    test_cmd+=(--packages-select "${packages_select[@]}")
  fi
  (
    cd "$WORKSPACE_DIR"
    "${test_cmd[@]}"
    colcon test-result --verbose
  )
fi
