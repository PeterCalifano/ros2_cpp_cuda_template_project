# Template Usage

Use this repository as a ROS2-native workspace template for generic C++/CUDA libraries.

1. Choose the project prefix, package names, C++ namespace, and whether optional packages are needed.
2. Run the cleanup helper before broad replacement:

   ```bash
   ./tailor_ros2_template_cleanup.sh --list
   ./tailor_ros2_template_cleanup.sh --apply --yes
   ```

3. Replace `template_project` with the chosen project prefix in tracked source files.
4. Rename the package directories under `ros2_ws/src`.
5. Rename include directories and public C++ namespaces.
6. Build and test:

   ```bash
   ./build_ros2_ws.sh --clean
   ```

The core package is intentionally free of `rclcpp` by default. Keep it that way unless the project truly needs a ROS2 dependency at the algorithm layer.

