# ros2_cpp_cuda_template_project

A GitHub-template-ready ROS2 workspace for generic C++/CUDA projects that need both a reusable core library and native ROS2 package build/install/run workflows.

The template combines the C++/CUDA engineering discipline of `cpp_cuda_template_project` with the high-level ROS2 workspace shape used by real multi-package projects such as `hyper_2`: interfaces, core library, lifecycle/composable nodes, spinup, containers, profiling, and testfield validation.

## Why This Exists

`ros2 pkg create` is the right minimal package generator, but it intentionally stops at a small scaffold. It does not provide production-grade C++ library exports, CUDA/OptiX toggles, wrapper hooks, profiling, documentation, CI, container deployment, or a multi-package workspace pattern.

Generic ROS2 container templates solve environment setup, but they usually do not define a reusable C++ package contract or separate the algorithmic core from ROS2 executors and middleware. Domain templates, including controller or robotics-specific templates, are often too coupled to their domain assumptions.

`cpp_cuda_template_project` already solves the standalone C++/CUDA library template problem. This repository exists for the adjacent problem: a generic C++/CUDA library that is also developed, installed, tested, and deployed as ROS2 packages through `ament_cmake` and `colcon`.

`hyper_2` is used as an architecture reference, not as source code to copy. This template keeps the package split and lifecycle/composable-node style while excluding robot-specific logic, private dependencies, fixed hardware configs, and hardcoded workspace paths.

## Comparison

| Source | Strength | Gap for this use case | Imported or adapted here |
| --- | --- | --- | --- |
| `cpp_cuda_template_project` | Generic C++/CUDA library template with CMake modules, CUDA/OptiX switches, profiling, docs, CI, wrapper direction, and testfield validation. | It is CMake-first, not a native ROS2 workspace, and does not provide `package.xml`, `ament_cmake`, `colcon`, ROS2 interfaces, lifecycle nodes, launch files, or ROS deployment containers. | Core-library package, exported CMake target, CUDA/profiling/sanitizer/compiler modules, docs/CI/container patterns, static template checks, and testfield workflow. |
| `hyper_2` | Real ROS2-native multi-package architecture with interfaces, reusable core behavior, nodes, launch/config, and containerized development. | It is domain-specific and includes project logic, private assumptions, and fixed package names that should not be copied into a generic template. | High-level package split, ROS wrapper boundary, lifecycle/composable node pattern, spinup layout, and container-first workflow. |
| `ros2 pkg create` | Minimal official ROS2 package bootstrap. | Too small for repeated C++/CUDA library projects with profiling, docs, CI, exported core targets, and runtime containers. | Kept as the baseline ROS2 package convention, then expanded into a reusable project template. |

## Package Layout

```text
ros2_ws/src/
  template_project_core/         Pure C++/CUDA library, no rclcpp dependency by default
  template_project_interfaces/   Placeholder messages and services
  template_project_nodes/        Lifecycle/composable ROS2 wrappers around the core
  template_project_spinup/      Launch files, YAML configs, runtime assets
  template_project_description/  Optional URDF/mesh placeholder package
```

Root-level tooling applies to the whole workspace:

```text
build_ros2_ws.sh                 colcon build/test helper
profiling/                       Core-library profiling scripts
docker/                          Development and runtime containers
.devcontainer/                   VS Code development container
doc/                             Template documentation and rollout notes
tests/template_checks/           Static template checks
```

## Quick Start

```bash
./build_ros2_ws.sh --clean
source ros2_ws/install/setup.bash
ros2 launch template_project_spinup template_project.launch.py
```

Build only the core package:

```bash
./build_ros2_ws.sh --packages-select template_project_core
```

Enable CUDA/OptiX options for the core package:

```bash
./build_ros2_ws.sh --cuda --cmake-arg -DCUDA_ARCHITECTURES=87
./build_ros2_ws.sh --cuda --optix --cmake-arg -DCUDA_ARCHITECTURES=87
```

Run deterministic core profiling without ROS2 executor overhead:

```bash
./build_ros2_ws.sh --profile-core --packages-select template_project_core
./profiling/run_core_call_profiling.sh
```

## Documentation

- [`doc/developments/ros2_cpp_cuda_template_plan.md`](doc/developments/ros2_cpp_cuda_template_plan.md): staged implementation plan.
- [`doc/template_usage.md`](doc/template_usage.md): how to tailor this template into a project.
- [`doc/ros2_workspace_build.md`](doc/ros2_workspace_build.md): colcon and package build workflow.
- [`doc/cpp_cuda_core.md`](doc/cpp_cuda_core.md): core C++/CUDA options.
- [`doc/profiling.md`](doc/profiling.md): core-only profiling policy and scripts.
- [`doc/containers.md`](doc/containers.md): development/runtime container workflows.
- [`doc/testing_and_ci.md`](doc/testing_and_ci.md): validation gates.
