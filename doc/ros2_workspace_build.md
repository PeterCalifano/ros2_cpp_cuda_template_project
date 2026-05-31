# ROS2 Workspace Build

The native build workflow is `colcon` over `ros2_ws`.

```bash
./build_ros2_ws.sh --clean
source ros2_ws/install/setup.bash
```

The helper sources `/opt/ros/${ROS_DISTRO:-jazzy}/setup.bash`, passes common CMake options, runs `colcon build --symlink-install`, and then runs `colcon test`.

Package-specific builds are supported:

```bash
./build_ros2_ws.sh --packages-select template_project_core
./build_ros2_ws.sh --packages-select template_project_interfaces template_project_nodes
```

Extra CMake and colcon arguments can be passed with repeatable options:

```bash
./build_ros2_ws.sh --cmake-arg -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
./build_ros2_ws.sh --colcon-arg --executor --colcon-arg sequential
```

