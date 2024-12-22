# environments

ROS2 
```
# Install docker and nvidia container toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

docker build -t ros2:latest -f ros2.Dockerfile .

xhost +;docker container rm ros2 --force; docker run -d --gpus all --network=host --name ros2 \
    --cap-add=sys_ptrace --security-opt seccomp=unconfined \
    -v /home:/home -v /mnt:/mnt -v /tmp/.x11-unix:/tmp/.x11-unix -v /tmp:/tmp -v ${HOME}/.gz:/root/.gz \
    --env="DISPLAY=$DISPLAY" --env="XAUTHORITY=$XAUTHORITY" --env="XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" ros2:latest
```
