# environments

## Pre-Requirements

```bash
curl -fsSL https://test.docker.com -o test-docker.sh | sh -
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/UbuntuMono.zip
# Install WezTerm: https://wezfurlong.org/wezterm/installation.html

# Add to .bashrc
if [[ $IN_DOCKER ]]; then PS1="\[\e[0;31m\][docker]\[\e[m\] $PS1"; fi
```

## Run
```bash
export CONTAINER_NAME=[container_name]
export BASE_IMAGE=${BASE_IMAGE:-ubuntu:24.04}
xhost +

# also has a ttyd on port 8195
docker exec -it $CONTAINER_NAME /bin/bash -l
# sudo
docker exec -u root -it $CONTAINER_NAME /bin/bash -l
```

## Build
```bash
# Vim
docker build --build-arg "BASE_IMAGE=$BASE_IMAGE" -t vim:latest -f vim.Dockerfile .

# ROS2
docker build --build-arg "BASE_IMAGE=$BASE_IMAGE" -t ros2:latest -f ros2.Dockerfile .

# Gazebo
## Install docker and nvidia container toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
docker build --build-arg "BASE_IMAGE=$BASE_IMAGE" -t gazebo:latest -f gazebo.Dockerfile .

```

## Run
```bash
# Vim
docker container rm vim --force
docker run --restart=always --name vim -d --network=host --user $(id -u):$(id -g) \
    --gpus all \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v /home/$USER:/home/$USER \
    --env="DISPLAY=$DISPLAY" \
    vim:latest

# ROS2
docker container rm ros2 --force
docker run --restart=always --name ros2 -d --network=host --user $(id -u):$(id -g) \
    --gpus all \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v /home/$USER:/home/$USER \
    --env="DISPLAY=$DISPLAY" \
    ros2:latest

# Gazebo
docker container rm gazebo --force
docker run --restart=always --name gazebo -d --network=host --user $(id -u):$(id -g) \
    --gpus all \
    --cap-add=sys_ptrace --security-opt seccomp=unconfined \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v /home/$USER:/home/$USER \
    -v /tmp/.x11-unix:/tmp/.x11-unix -v /tmp:/tmp \
    --env="DISPLAY=$DISPLAY" --env="XAUTHORITY=$XAUTHORITY" --env="XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" gazebo:latest
```
