# Base image with specified ROS distribution
ARG ROS_DISTRO=galactic
FROM dustynv/ros:galactic-desktop-l4t-r35.4.1

# Setting the shell environment
ENV SHELL /bin/bash
SHELL ["/bin/bash", "-c"]

# Setting up the ROS 2 workspace
WORKDIR /ros2_ws

# Cloning the Orbbec SDK into the ROS 2 workspace
# This command clones the Orbbec SDK from its Git repository into the src directory of the workspace.
RUN mkdir -p src && \
    git clone https://github.com/orbbec/OrbbecSDK_ROS2.git src/OrbbecSDK_ROS2

# Installing necessary tools and dependencies for the ROS package
# This includes various dependencies required by ROS and the Orbbec SDK.
# Use the apt purge command to uninstall OpenCV 4.2, as it interferes with OpenCV 4.5. 4.5 is required by the OrbbecSDK.
RUN apt update && \
    apt purge -y opencv-dev opencv-libs && \
    apt install -y libgflags-dev \
        nlohmann-json3-dev \
        libgoogle-glog-dev \
        gnome-terminal \
        ros-$ROS_DISTRO-ament-lint-auto \
        ros-$ROS_DISTRO-ament-cmake \
        ros-$ROS_DISTRO-rosidl-default-generators \
        ros-$ROS_DISTRO-std-srvs \
        ros-$ROS_DISTRO-tf2 \
        ros-$ROS_DISTRO-tf2-eigen \
        ros-$ROS_DISTRO-tf2-sensor-msgs \
        ros-$ROS_DISTRO-image-transport \
        ros-$ROS_DISTRO-image-publisher \
        ros-$ROS_DISTRO-camera-info-manager \
    && rm -rf /var/lib/apt/lists/*

# Here, we source the ROS setup script to ensure the environment is properly configured,
# then use `colcon build` to compile the ROS workspace.
RUN source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --event-handlers console_direct+ --cmake-args -DCMAKE_BUILD_TYPE=Release

# Setting the stop signal for container shutdown
# This is important for ensuring graceful shutdown of the camera.
# STOPSIGNAL SIGINT
STOPSIGNAL SIGTERM
