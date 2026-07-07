# ROS2 C++/CUDA Template Project Plan

## Summary

This repository is intended to become a GitHub template for generic C++/CUDA projects that must also build, install, test, and run as native ROS2 packages. It should merge the disciplined CMake/CUDA/library infrastructure from `cpp_cuda_template_project` with the high-level ROS2 workspace architecture visible in `hyper_2`: interfaces, reusable core logic, lifecycle/composable nodes, spinup assets, containerized workflows, and deployment entrypoints.

The template is not a `hyper_2` clone. `hyper_2` is only the architecture reference for a real multi-package ROS2 workspace. Robot-specific code, private dependencies, fixed hardware assumptions, and hardcoded workspace paths are excluded.

The sibling testfield repository must be created early and kept equivalent in spirit to `cpp_cuda_template_testfield`: a concrete project initialized from the template, renamed away from placeholders, and used to prove that the template actually works after tailoring.

## Conceptual Comparison For README

- [ ] Explain that `ros2 pkg create` is a useful minimum package generator, but it does not provide production-grade C++ library boundaries, CUDA/OptiX handling, wrapper support, profiling, docs, CI, container deployment, or multi-package project structure.
- [ ] Explain that generic ROS2 Docker/devcontainer templates help with environment setup, but usually do not solve reusable C++ package exports, core-vs-node separation, CUDA options, or downstream library consumption.
- [ ] Explain that domain templates such as controller, simulation, or Autoware-style templates are valuable but too domain-specific for generic reusable C++/CUDA projects.
- [ ] Explain that `cpp_cuda_template_project` already solves the standalone C++/CUDA library problem, but it is CMake-first and not native to `colcon`, `package.xml`, `ament_cmake`, ROS2 interfaces, lifecycle nodes, launch files, or ROS deployment containers.
- [ ] Explain that `hyper_2` demonstrates the target ROS2 project shape, but it is a robot application, not a reusable template.
- [ ] State the target gap clearly: a generic C++/CUDA template whose primary build/install workflow is ROS2-native while preserving clean C++ library engineering.

## Target Repository Layout

- [ ] Create `ros2_ws/src/template_project_core` as the pure C++/CUDA package.
- [ ] Create `ros2_ws/src/template_project_interfaces` for placeholder `msg`, `srv`, and optional `action` definitions.
- [ ] Create `ros2_ws/src/template_project_nodes` for ROS2 lifecycle and composable node wrappers around the core library.
- [ ] Create `ros2_ws/src/template_project_spinup` for launch files, YAML configs, RViz config, runtime scripts, and installed share assets.
- [ ] Create `ros2_ws/src/template_project_description` as an optional placeholder for URDF/mesh assets.
- [ ] Add `ros2_ws/src/template_project_visualization` only if the initial scaffold has a generic visualization example that is worth maintaining.
- [ ] Keep root-level `doc/`, `.github/`, `.devcontainer/`, `docker/`, `profiling/`, and helper scripts outside `ros2_ws` so they apply to the workspace template as a whole.
- [ ] Avoid hardcoded paths such as `/root/ros2_ws/install/...`; all package discovery must go through `find_package`, `ament_index_cpp`, install prefixes, or sourced setup files.

## Stage 0 - Planning Repository Bootstrap

- [ ] Create `/home/peterc/devDir/dev-tools/ros2_cpp_cuda_template_project`.
- [ ] Write this plan to `doc/developments/ros2_cpp_cuda_template_plan.md`.
- [ ] Add a short root `README.md` stub that points to this plan and states that implementation has not started.
- [ ] Add `AGENTS.md` derived from the current dev-tools conventions, including the instruction to update `CONTEXT.md` before compaction.
- [ ] Add `CONTEXT.md` with the current planning state and no implementation claims.
- [ ] Initialize git only after the user approves the repository skeleton.

## Stage 1 - Minimal ROS2 Workspace Skeleton

- [ ] Add `ros2_ws/src/template_project_core/package.xml` using package format 3 and `ament_cmake`.
- [ ] Add `template_project_core/CMakeLists.txt` with C++20, clean install/export rules, and no ROS runtime dependency by default.
- [ ] Add a small core class, for example `CTemplateAlgorithm`, with deterministic behavior and no `rclcpp` include.
- [ ] Add a core executable or benchmark entrypoint that calls the library directly.
- [ ] Add `ros2_ws/src/template_project_interfaces/package.xml` and one placeholder message/service pair.
- [ ] Add `ros2_ws/src/template_project_nodes/package.xml` and a lifecycle node that wraps `CTemplateAlgorithm`.
- [ ] Add one standalone node executable and one composable node registration.
- [ ] Add `ros2_ws/src/template_project_spinup/package.xml`, one launch file, and one YAML config.
- [ ] Add `build_ros2_ws.sh` with the smallest useful interface: clean, build type, package selection, tests on/off, and extra CMake args.
- [ ] Test immediately with `colcon build --symlink-install` from `ros2_ws`.
- [ ] Test immediately with `colcon test` and `colcon test-result --verbose`.

## Stage 2 - Early Testfield Repository

- [ ] Create `/home/peterc/devDir/dev-tools/ros2_cpp_cuda_template_testfield` as soon as Stage 1 builds.
- [ ] Initialize it from the template by copying the current scaffold, not by manually writing a separate project.
- [ ] Rename placeholders to a concrete project name, for example `ros2_template_testfield`.
- [ ] Rename packages consistently, for example `ros2_template_testfield_core`, `ros2_template_testfield_interfaces`, `ros2_template_testfield_nodes`, and `ros2_template_testfield_spinup`.
- [ ] Remove or adapt template-only files exactly as a downstream user would.
- [ ] Build the testfield with `colcon build --symlink-install`.
- [ ] Run `colcon test` and `colcon test-result --verbose` in the testfield.
- [ ] Keep the testfield dirty-state policy identical in spirit to the existing C++/CUDA testfield: it validates template behavior and may intentionally mirror template infrastructure changes.
- [ ] Add every later template feature to the testfield soon after it lands in the template.

## Stage 3 - Import Core CMake Infrastructure

- [ ] Port reusable CMake modules from `cpp_cuda_template_project/cmake` into the ROS2 template where compatible.
- [ ] Preserve CUDA architecture detection, including explicit `CUDA_ARCHITECTURES` and `CMAKE_CUDA_ARCHITECTURES` override paths.
- [ ] Preserve CUDA options: FMAD, extra device vectorization, regular fast math, PTX fast math, and extra NVCC flags.
- [ ] Preserve OptiX support as an optional core-library feature, with clear configure errors when required PTX/library structure is missing.
- [ ] Preserve CPU tuning options: native tuning, SIMD level, FMA, extra optimization flags, and cross-compile-safe defaults.
- [ ] Preserve OpenMP, TBB, OpenGL, ZeroMQ, and spdlog hooks when they can be package-local and optional.
- [ ] Preserve sanitizer support, but ensure sanitizer flags apply to selected packages and do not silently leak into unrelated ROS2 dependencies.
- [ ] Preserve version resolution from git tags and build/install `VERSION` files where compatible with colcon overlays.
- [ ] Keep CPack only if it does not fight ROS2/ament install conventions; otherwise document why it is deferred.
- [ ] Validate the template and testfield after each imported module group.

## Stage 4 - Core Library Package Contract

- [ ] Export `template_project_core::template_project_core`.
- [ ] Support downstream CMake consumers with `find_package(template_project_core REQUIRED)`.
- [ ] Support downstream ROS2 overlay consumers through normal `colcon` workspace sourcing.
- [ ] Add installed headers under a predictable include path.
- [ ] Keep core package dependencies minimal: Eigen/spdlog/CUDA/etc. are acceptable; `rclcpp` is not unless explicitly enabled by a future option.
- [ ] Add a nested consumer example or CMake test proving the installed core target can be consumed outside the workspace.
- [ ] Add a ROS2 package consumer test proving another ament package can link the core target.
- [ ] Mirror the same tests in the testfield.

## Stage 5 - Interfaces And ROS2 Node Layer

- [ ] Add placeholder `AlgorithmStatus.msg`.
- [ ] Add placeholder `RunAlgorithm.srv`.
- [ ] Add interface generation with `rosidl_generate_interfaces`.
- [ ] Keep generated interfaces in the interface package, not the core package.
- [ ] Implement a lifecycle node that loads parameters, owns a core algorithm instance, and exposes ROS subscriptions/services/timers.
- [ ] Implement a composable node registration path.
- [ ] Add launch files for standalone and composed execution.
- [ ] Add a launch test or smoke test proving the node can start with the installed config.
- [ ] Add lifecycle configure/activate/deactivate tests.
- [ ] Mirror interface and node tests in the testfield.

## Stage 6 - Containerized Development And Runtime

- [ ] Add `.devcontainer/devcontainer.json`.
- [ ] Add `.devcontainer/Dockerfile` or connect the devcontainer to the main multi-stage Dockerfile.
- [ ] Add `docker/Dockerfile` with `base`, `deps`, `dev`, `builder`, and `runtime` stages.
- [ ] Add `rosdep install --from-paths ros2_ws/src -i -r -y --rosdistro ${ROS_DISTRO}` to the dependency stage.
- [ ] Add GPU/CUDA support in a way that is optional and documented.
- [ ] Add `docker/entrypoint.sh` for development shells.
- [ ] Add `docker/runtime_entrypoint.sh` for installed runtime execution.
- [ ] Add `docker/run_dev_container.sh` with host networking, X11/Wayland notes where needed, GPU option, and workspace mount.
- [ ] Add `docker/run_runtime_container.sh` for deployment-style execution from installed artifacts.
- [ ] Add examples for `ROS_DOMAIN_ID`, local-only discovery, device mounts, and environment sourcing.
- [ ] Do not hardcode robot-specific CAN, IMU, joystick, or actuator devices; provide placeholders and comments only.
- [ ] Test Docker `dev` stage build.
- [ ] Test Docker `runtime` stage build.
- [ ] Test runtime entrypoint with a harmless command or node smoke.
- [ ] Mirror container tests in the testfield when practical.

## Stage 7 - Profiling Adapted For Core Library Only

- [ ] Keep profiling tools focused on `template_project_core` and its direct benchmark executables.
- [ ] Do not profile ROS2 executors, DDS/middleware, launch, lifecycle transitions, parameter parsing, or message serialization by default.
- [ ] Add `template_project_core_benchmark` as a deterministic executable that exercises the algorithm without starting ROS2.
- [ ] Add `profiling/run_core_call_profiling.sh` for call profiling.
- [ ] Add `profiling/run_core_mem_complexity.sh` for Valgrind Massif or equivalent memory profiling.
- [ ] Add `profiling/run_core_ops_profiling.sh` for perf/instruction-oriented profiling.
- [ ] Ensure profiling scripts reject ROS2 node executables by default unless an explicit override is passed.
- [ ] Add `--profile-core` to `build_ros2_ws.sh`.
- [ ] Make `--profile-core` apply profiler-friendly flags only to `template_project_core` unless explicit propagation is requested.
- [ ] Keep allocator/profiler dependencies private to the benchmark/core package by default.
- [ ] Add optional `profiling/run_ros2_integration_timing.sh`, clearly labeled as integration timing rather than core-library profiling.
- [ ] Test that core profiling runs without sourcing ROS2 when using build-tree binaries.
- [ ] Test that installed core profiling works after sourcing the workspace setup.
- [ ] Mirror profiling checks in the testfield.

## Stage 8 - Wrappers As Optional Core Feature

- [ ] Port gtwrap Python wrapper support only for `template_project_core`.
- [ ] Port MATLAB wrapper support only for `template_project_core`.
- [ ] Keep wrappers disabled by default.
- [ ] Document wrappers as non-ROS API bindings for the core library, not replacements for ROS2 messages/services.
- [ ] Preserve Python package metadata generation where compatible.
- [ ] Preserve MATLAB wrapper regression structure where practical.
- [ ] Ensure wrapper options do not affect ROS2 node packages unless explicitly requested.
- [ ] Add wrapper build smoke tests when local dependencies are available.
- [ ] Add skipped/conditional tests when dependencies are absent.
- [ ] Mirror wrapper behavior in the testfield after the core path is stable.

## Stage 9 - Documentation And GitHub Template Experience

- [ ] Add full `README.md` with the comparison section defined above.
- [ ] Add a documentation map similar to `cpp_cuda_template_project`.
- [ ] Add `doc/template_usage.md` for renaming and tailoring.
- [ ] Add `doc/ros2_workspace_build.md` for colcon, ament, package selection, overlays, and install behavior.
- [ ] Add `doc/cpp_cuda_core.md` for CUDA/OptiX/core-library options.
- [ ] Add `doc/containers.md` for dev and runtime containers.
- [ ] Add `doc/profiling.md` emphasizing core-only profiling.
- [ ] Add `doc/wrappers.md` for optional Python/MATLAB wrappers.
- [ ] Add `doc/testing_and_ci.md` for local and CI gates.
- [ ] Add Doxygen config and Pages workflow adapted to the ROS2 workspace.
- [ ] Ensure docs exclude generated build/install/log directories.
- [ ] Test docs generation locally.
- [ ] Mirror docs generation in the testfield.

## Stage 10 - Tailoring And Template Cleanup

- [ ] Add `tailor_ros2_template_cleanup.sh --list`.
- [ ] Add `tailor_ros2_template_cleanup.sh --apply --yes`.
- [ ] Add options to keep or remove optional packages: description, visualization, CUDA skeleton, wrappers, profiling, and deployment scripts.
- [ ] Ensure cleanup runs before broad placeholder replacement.
- [ ] Ensure cleanup removes template-development-only tests and docs but keeps reusable infrastructure.
- [ ] Add a sample rename validation script or CMake/Python test.
- [ ] Test cleanup on a temporary copy.
- [ ] Use the testfield as the real downstream proof after cleanup and rename.

## Stage 11 - CI Matrix

- [ ] Add GitHub Actions workflow for CPU ROS2 build and test.
- [ ] Add GitHub Actions workflow for CUDA build when a suitable runner is available.
- [ ] Add workflow for Docker dev/runtime image build.
- [ ] Add docs Pages workflow with manual deploy control and default-branch deploy guard.
- [ ] Add static workflow checks analogous to the current template checks.
- [ ] Add tests requiring full-history checkout where version resolution depends on tags.
- [ ] Add matrix entries for Debug and Release or RelWithDebInfo.
- [ ] Add package-select smoke for the core package alone.
- [ ] Add package-select smoke for nodes plus interfaces.
- [ ] Add CI proof that testfield builds against the current template state where practical.

## Stage 12 - Acceptance Gate

- [ ] Template builds from a clean checkout with `./build_ros2_ws.sh --clean`.
- [ ] Template passes `colcon test` and `colcon test-result --verbose`.
- [ ] Template core package installs and can be consumed by a non-ROS CMake project.
- [ ] Template core package can be consumed by another ament package.
- [ ] Template lifecycle node starts from launch.
- [ ] Template composed node starts from launch.
- [ ] Core profiling runs against the benchmark without ROS2 executor overhead.
- [ ] Dev container builds and supports interactive development.
- [ ] Runtime container builds and runs an installed smoke command.
- [ ] Docs build locally.
- [ ] Tailoring cleanup works on a temporary copy.
- [ ] Testfield exists, is renamed, builds, tests, and mirrors the main template gates.
- [ ] README comparison clearly explains why this template exists.

## Explicit Non-Goals For V1

- [ ] Do not import `hyper_2` robot logic.
- [ ] Do not import private DFKI dependencies.
- [ ] Do not include fixed robot URDFs, meshes, or hardware configs.
- [ ] Do not make ROS2 middleware profiling the default profiling path.
- [ ] Do not require CUDA for CPU-only projects.
- [ ] Do not require Python/MATLAB wrappers for ROS2 package use.
- [ ] Do not solve every possible deployment target before the core template and testfield are green.

## Notes For Implementation Order

- [ ] Start with the smallest working ROS2 workspace before porting advanced CMake features.
- [ ] Create the testfield immediately after the minimal workspace builds and tests.
- [ ] Add each major feature to the template and then validate it in the testfield before moving to the next feature group.
- [ ] Keep source-of-truth ownership clear: core algorithm code belongs in `template_project_core`; ROS graph behavior belongs in `template_project_nodes`; launch/config/deployment belongs in `template_project_spinup` or `docker`.
- [ ] Prefer direct, package-local CMake over global workspace state.
- [ ] Keep the template generic enough for non-robot ROS2 applications.
