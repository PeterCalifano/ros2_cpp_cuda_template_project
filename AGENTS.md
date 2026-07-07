# Agents instructions

Write to `CONTEXT.md` before compaction to prevent data loss.
After auto-compaction, read `AGENTS.md` and `CONTEXT.md` before restarting.

This repository is a ROS2-native C++/CUDA template. Keep the core C++ library independent of ROS2 unless a task explicitly asks to change that boundary. ROS2 graph behavior belongs in node packages; launch/config/runtime behavior belongs in spinup or container files.

For C++/CUDA:
- Use C++20 by default and keep CUDA optional.
- Prefer concepts over SFINAE.
- Prefer classes over structs.
- Keep public headers installed and package exports clean.
- Unit tests should use Catch2 where practical.
- Core-library profiling must avoid ROS2 executors, middleware, launch, lifecycle setup, parameter parsing, and message serialization by default.

For ROS2:
- Use `ament_cmake` and `colcon` as the native build path.
- Do not hardcode install prefixes or workspace paths.
- Keep `package.xml` dependencies aligned with CMake dependencies.
- Prefer lifecycle/composable node examples for reusable components.

