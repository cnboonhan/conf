# environments

```
podman build -t ros2:latest -f ros2.Containerfile .
podman run -it --network host --rm ros2:latest bash
```