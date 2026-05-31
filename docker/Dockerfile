# syntax=docker/dockerfile:1
ARG ROS_DISTRO=jazzy

FROM ros:${ROS_DISTRO} AS base
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    catch2 \
    cmake \
    git \
    python3-colcon-common-extensions \
    python3-pip \
    python3-pytest \
    ros-dev-tools \
    && rm -rf /var/lib/apt/lists/*

FROM base AS deps
WORKDIR /workspace
COPY ros2_ws/src ./ros2_ws/src
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && rosdep update \
    && rosdep install --from-paths ros2_ws/src -i -r -y --rosdistro ${ROS_DISTRO}

FROM deps AS dev
WORKDIR /workspace
COPY . .
RUN chmod +x build_ros2_ws.sh docker/entrypoint.sh docker/runtime_entrypoint.sh
ENTRYPOINT ["/workspace/docker/entrypoint.sh"]
CMD ["bash"]

FROM deps AS builder
WORKDIR /workspace
COPY . .
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && cd ros2_ws \
    && colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release \
    && colcon test --event-handlers console_direct+ \
    && colcon test-result --verbose

FROM ros:${ROS_DISTRO} AS runtime
SHELL ["/bin/bash", "-c"]
WORKDIR /workspace
COPY --from=builder /workspace/ros2_ws/install ./install
COPY docker/runtime_entrypoint.sh /runtime_entrypoint.sh
RUN chmod +x /runtime_entrypoint.sh
ENTRYPOINT ["/runtime_entrypoint.sh"]
CMD ["ros2", "launch", "template_project_bringup", "template_project.launch.py"]
