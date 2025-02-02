# environments

## Initialization
```bash
# install WezTerm: https://wezfurlong.org/wezterm/installation.html
sudo apt install rclone curl wget git -y
curl -fsSL https://test.docker.com | sh -
mkdir -p ~/.fonts && curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip -o /tmp/fonts.zip
unzip -d ~/.fonts/UbuntuMono /tmp/fonts.zip && fc-cache -f -v
[[ $(command -v nvidia-smi) ]] && sudo nvidia-ctk runtime configure --runtime=docker && sudo systemctl restart docker
echo 'if [[ $IN_DOCKER ]]; then PS1="\[\e[0;31m\][docker]\[\e[m\] $PS1"; fi' >> ~/.bashrc
# If using podman, alias docker="podman"
# rclone mount gdrive:/ ~/gdrive --daemon
```

## Build
```bash
export BASE_IMAGE=${BASE_IMAGE:-ubuntu:24.04}
export TARGET="vim" 
docker build --build-arg "BASE_IMAGE=$BASE_IMAGE" -t "$TARGET":latest -f "$TARGET.Dockerfile" .
sed -i '/^alias z=/d' ~/.bashrc && echo "alias z='docker exec -it $TARGET bash -c \"cd \"\$PWD\" && bash -l\"'" >> ~/.bashrc
sed -i '/^alias Z=/d' ~/.bashrc && echo "alias Z='docker exec -u root -it $TARGET bash -c \"cd \"\$PWD\" && bash -l\"'" >> ~/.bashrc
```

## Run
```bash
export TARGET="vim" 
docker container rm "$TARGET" --force
docker run \
    --restart=always --name "$TARGET" -d --network=host --user $(id -u):$(id -g) \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v "/home/$USER:/home/$USER" -v "/opt:/opt" \
    --env="DISPLAY=$DISPLAY" \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    $(if command -v podman &> /dev/null; then echo "--userns=keep-id --privileged"; fi) \
    $(if ! command -v podman &> /dev/null; then echo "-v /var/run/docker.sock:/var/run/docker.sock"; fi) \
    $(if command -v nvidia-smi &> /dev/null; then echo "--gpus all --env NVIDIA_DRIVER_CAPABILITIES=all --runtime=nvidia"; fi) "$TARGET:latest"
```

