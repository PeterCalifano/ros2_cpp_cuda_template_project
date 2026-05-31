# C++/CUDA Core

`template_project_core` owns the reusable C++/CUDA library. ROS2-facing packages link it, but it does not depend on `rclcpp` by default.

Useful options:

| Option | Default | Purpose |
|---|---:|---|
| `TEMPLATE_PROJECT_ENABLE_CUDA` | `OFF` | Enable CUDA language and CUDA compile interface. |
| `TEMPLATE_PROJECT_ENABLE_OPTIX` | `OFF` | Reserve OptiX support path; implies CUDA. |
| `TEMPLATE_PROJECT_PROFILE_CORE` | `OFF` | Apply profiler-friendly flags to the core package. |
| `TEMPLATE_PROJECT_WARNINGS_AS_ERRORS` | `OFF` | Treat core warnings as errors. |
| `BUILD_SHARED_LIBS` | `ON` | Build the core library as shared by default for ROS2 components. |

The CMake module set is imported from `cpp_cuda_template_project` into `template_project_core/cmake` so CUDA architecture detection, compiler flags, sanitizer handling, profiling hooks, and related options remain close to the core package.

