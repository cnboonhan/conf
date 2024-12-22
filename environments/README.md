# environments

ROS2 
```
podman build -t ros2:latest -f ros2.Containerfile .

podman run -d --gpus all --network=host --name ros2 --replace  \
    --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    -v /home:/home -v /mnt:/mnt -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp:/tmp \
    -e DISPLAY=${DISPLAY} ros2:latest
```