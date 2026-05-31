# Testing And CI

Primary local gate:

```bash
./build_ros2_ws.sh --clean
```

This runs:

1. `colcon build --symlink-install`
2. `colcon test`
3. `colcon test-result --verbose`

The core package uses Catch2 for deterministic library tests. ROS2 node packages use ament/gtest smoke tests for lifecycle construction and configuration.

CI should cover:

- CPU ROS2 build and test.
- CUDA build where a suitable runner is available.
- Docker dev/runtime image build.
- Static template checks.
- Documentation generation.
- Testfield build/test once the sibling testfield repository is available in CI.

