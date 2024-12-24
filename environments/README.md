# environments

## Build
```
# Vim
docker build -t vim:latest -f vim.Dockerfile .

# ROS2
docker build -t ros2:latest -f ros2.Dockerfile .

# Gazebo
## Install docker and nvidia container toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
docker build -t gazebo:latest -f gazebo.Dockerfile .

```

## Run
```
# Vim
docker container rm vim --force
docker run --name vim -d --network=host --user $(id -u):$(id -g) \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v /home:/home \
    -e "OPENAI_API_KEY=$OPENAI_API_KEY" \
    vim:latest

# ROS2
docker container rm ros2 --force
docker run --name ros2 -d --network=host --user $(id -u):$(id -g) \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v /home:/home \
    ros2:latest

# Gazebo
xhost +
docker container rm gazebo --force
docker run --name gazebo -d --network=host --user $(id -u):$(id -g) \
    --gpus all \
    --cap-add=sys_ptrace --security-opt seccomp=unconfined \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v /home:/home \
    -v /tmp/.x11-unix:/tmp/.x11-unix -v /tmp:/tmp \
    --env="DISPLAY=$DISPLAY" --env="XAUTHORITY=$XAUTHORITY" --env="XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" gazebo:latest
```
