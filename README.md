# femto-ros2
Dockerfile to run Orbbec Femto on NVIDIA Jetson Xavier and Orin

This is a sketch of a Dockerfile to build a Docker image which runs an Orbbec Femto camera on a ROS 2 galactic desktop on Jetson JetPack 5. This include Jetson Orin and Jetson Xavier. This Docker image is built on the dustynv/ros:galactic-desktop-l4t-r35.4.1 Docker image. This Dockerfile is not meant to be production ready, but rather a guide on some of the necessary steps to install the Orbbec SDK into a ROS2 Dockerfile.

As usual, make sure to add yourself to the 'docker' group. In order to build the Docker Image:

```
docker build --tag jetsonhacks/ros2:galactic-desktop-l4t-r35.4.1 .
```
Follow the directions for setting up the Orbbec camera udev rules for accessing the camera. https://github.com/orbbec/OrbbecSDK Environment setup instructions here once you download the OrbbecSDK: https://github.com/orbbec/OrbbecSDK?tab=readme-ov-file#environment-setup

You will need to be able to access the Orbbec camera outside of the Docker container on the Jetson.

The script run.sh is a convenience file from the way excellent dusty-nv/jetson-containers (https://github.com/dusty-nv/jetson-containers) repository. This will allow you to run the Docker image in a straightforward manner. As an example to run the Docker image:

```
./run.sh jetsonhacks/ros2:galactic-desktop-l4t-r35.4.1
```

Once in the image, setup the environment. Then you should be able to launch the camera:

```
source /ros2_ws/install/setup.bash
ros2 launch orbbec_camera femto_bolt.launch.py & rviz2 & gnome-terminal
```

This will launch rviz2. You can then add the camera feeds and point cloud. Setting the fixed frame to camera_depth_frame will allow you to visualize the point cloud.

## Notes
The default galactic-desktop for L4T 35.4.1 uses OpenCV 4.2. The Orbbec SDK uses OpenCV 4.5. In the Dockerfile, OpenCV 4.2 is purged and replaced with OpenCV 4.5. This may cause conflicts with other packages.
For example:
'/usr/bin/ld: warning: libopencv_calib3d.so.4.2, needed by /opt/ros/galactic/lib/libimage_geometry.so, may conflict with libopencv_calib3d.so.4.5'

### Initial Release, March 2024
* Initial build and test on Jetson AGX Orin
* Femto Bolt
* L4T 35.4.1
