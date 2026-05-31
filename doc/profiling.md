# Profiling

Profiling defaults to the pure core library. The scripts in `profiling/` resolve `template_project_core_benchmark` and refuse ROS2-facing executables by default.

This is intentional. ROS2 executors, DDS middleware, launch processing, lifecycle transitions, parameter parsing, and message serialization are integration costs. They are useful to measure, but they should not be mixed with algorithm/core-library profiling.

## Core Profiling

```bash
./build_ros2_ws.sh --profile-core --packages-select template_project_core
./profiling/run_core_call_profiling.sh
./profiling/run_core_mem_complexity.sh
./profiling/run_core_ops_profiling.sh
```

Use `--args` to pass benchmark arguments:

```bash
./profiling/run_core_ops_profiling.sh --args 1000000
```

Use `--dry-run` to check command resolution:

```bash
./profiling/run_core_call_profiling.sh --dry-run
```

## ROS2 Integration Timing

`profiling/run_ros2_integration_timing.sh` is a placeholder for launch and service round-trip timing. It is labeled separately so reports do not confuse middleware/executor costs with core algorithm performance.

