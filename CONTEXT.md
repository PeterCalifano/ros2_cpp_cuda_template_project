# Current Context

- Main repo: `/home/peterc/devDir/dev-tools/ros2_cpp_cuda_template_project`
- Planned testfield repo: `/home/peterc/devDir/dev-tools/ros2_cpp_cuda_template_testfield`
- Reference template: `/home/peterc/devDir/dev-tools/cpp_cuda_template_project`
- Architecture reference: `/home/peterc/devDir/projects-DFKI/hyper_2`
- Date: 2026-05-31

## Implementation status

- Planning document exists at `doc/developments/ros2_cpp_cuda_template_plan.md`.
- Implementation is complete for the current scaffold toward a ROS2-native C++/CUDA template plus a renamed testfield repository.
- The template must preserve the core-vs-ROS boundary: core library code remains free of `rclcpp`; ROS2 wrapping lives in node packages.
- Profiling support must focus on deterministic core-library benchmark executables, not ROS2 executors or middleware.
- Current package split:
  - `template_project_core`: standalone C++ core library, example app, benchmark app, Catch2 tests, exported CMake target.
  - `template_project_interfaces`: message/service definitions for ROS-facing contracts.
  - `template_project_nodes`: lifecycle/component wrapper around the core library.
  - `template_project_spinup`: launch files, config, and run helper.
  - `template_project_description`: placeholder URDF package.
- Imported cpp/cuda-template facilities currently include copied CMake modules, compiler/sanitizer/profiling/CUDA options, docs workflow, Docker/devcontainer support, profiling scripts, static template checks, standalone core consumer example, and cleanup/tailoring helper.
- Wrapper options for Python/MATLAB exist as explicit CMake options but intentionally fail with a clear message until wrapper design is chosen for the ROS2 package split.
- CUDA option was verified locally with CUDA 12.9 using `./build_ros2_ws.sh --packages-select template_project_core --cuda`.
- Doxygen was verified with `doxygen doc/Doxyfile` after changing the output directory to `build_docs`.
- Docker runtime image build was corrected to run `colcon` from `ros2_ws` and to use a normal install instead of symlink install, so copied runtime images are self-contained.
- Docker runtime smoke verified `ros2 pkg prefix template_project_spinup` and a timeout launch of `template_project.launch.py`.
- Docker dev target was verified by running `./build_ros2_ws.sh --packages-select template_project_core --skip-tests` inside the image.
- Testfield repo exists at `/home/peterc/devDir/dev-tools/ros2_cpp_cuda_template_testfield` with placeholders renamed to `ros2_template_testfield_*`, `CTestfieldAlgorithm`, and `CTestfieldLifecycleNode`.
- Testfield has passed static template checks, Doxygen, full local ROS2 build/test, CUDA core build, profiling dry-runs, standalone core consumer linking, launch show-args, timeout launch smoke, and runtime Docker build/launch smoke.
- Both repositories were initialized with `git init -b main`, but no commits were created.
- Local full clean builds pass in both repos, with one non-fatal ROS interface generation stderr warning in the fresh uncommitted git repos: `listing git files failed - pretending there aren't any`.
