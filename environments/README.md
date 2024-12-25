# environments

## Pre-Requirements

```bash
curl -fsSL https://test.docker.com -o test-docker.sh | sh
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/UbuntuMono.zip
curl -L https://downloader.cursor.sh/linux/appImage/x64 -o /opt/cursor.appimage
```

## Run
```bash
CONTAINER_NAME=[container_name]
xhost +
docker exec -it $CONTAINER_NAME /bin/bash -l
docker exec -u root -it $CONTAINER_NAME /bin/bash -l
```

## Build
```bash
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
```bash
# Vim
docker container rm vim --force
docker run --name vim -d --network=host --user $(id -u):$(id -g) \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v /home:/home \
    --env="DISPLAY=$DISPLAY" \
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
