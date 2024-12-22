FROM ubuntu:24.04

RUN apt update && apt install curl git sudo wget -y
RUN sudo apt install software-properties-common  -y
RUN sudo add-apt-repository universe

# ROS2 Jazzy
RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Gazebo Ionic
RUN sudo curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

RUN sudo apt update && sudo apt upgrade -y

RUN sudo apt install ros-jazzy-desktop -y
RUN sudo apt install gz-ionic -y

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc