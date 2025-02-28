# environments

## Initialization
```bash
# install WezTerm: https://wezfurlong.org/wezterm/installation.html
# install miniConda: https://docs.anaconda.com/miniconda/install/#quick-command-line-install
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
sed -i '/^alias c=/d' ~/.bashrc && echo "alias c='source $HOME/miniconda3/bin/activate'" >> ~/.bashrc
sed -i '/^alias r=/d' ~/.bashrc && echo "alias r='rclone mount gdrive:/ $HOME/gdrive --daemon'" >> ~/.bashrc
```

## Run
```bash
export TARGET="vim" 
docker container rm "$TARGET" --force
docker run \
    --restart=always --name "$TARGET" -d --network=host --user $(id -u):$(id -g) \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v "/home/$USER:/home/$USER" -v "/opt:/opt" -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "/dev/bus/usb:/dev/bus/usb" \
    -v "/mnt:/mnt" \
    --env="DISPLAY=$DISPLAY" \
    --device /dev/fuse \
    --cap-add SYS_ADMIN \
    --privileged \
    $(if command -v podman &> /dev/null; then echo "--userns=keep-id"; fi) \
    $(if ! command -v podman &> /dev/null; then echo "-v /var/run/docker.sock:/var/run/docker.sock"; fi) \
    $(if command -v nvidia-smi &> /dev/null; then echo "--gpus all --env NVIDIA_DRIVER_CAPABILITIES=all"; fi) "$TARGET:latest"
```
