# Containers

The template includes both development and runtime container paths.

Development containers should mount the workspace and use `colcon build --symlink-install` for normal iteration. Runtime containers should copy the source, build in an isolated stage, and run from installed artifacts.

```bash
docker build -f docker/Dockerfile --target dev -t template-project-dev .
docker build -f docker/Dockerfile --target runtime -t template-project-runtime .
```

Run helpers:

```bash
./docker/run_dev_container.sh
./docker/run_runtime_container.sh
```

The helper scripts expose placeholders for `ROS_DOMAIN_ID`, GPU support, and device mounts. They do not hardcode robot-specific devices.

