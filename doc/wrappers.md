# Python And MATLAB Wrappers

Wrapper support is a core-library feature. It is intentionally not part of the ROS2 interface package and should not replace ROS2 messages, services, or actions.

The CMake wrapper modules from `cpp_cuda_template_project` are imported into the core package's CMake module tree for future use. Wrapper options should remain disabled by default and should only affect `template_project_core`.

Planned options:

| Option | Default |
|---|---:|
| `TEMPLATE_PROJECT_BUILD_PYTHON_WRAPPER` | `OFF` |
| `TEMPLATE_PROJECT_BUILD_MATLAB_WRAPPER` | `OFF` |

