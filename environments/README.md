# environments

## Initialization
```bash
curl -fsSL https://test.docker.com | sh -
mkdir -p ~/.fonts && curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.zip -o /tmp/fonts.zip
unzip -d ~/.fonts/UbuntuMono /tmp/fonts.zip && fc-cache -f -v
[[ $(command -v nvidia-smi) ]] && sudo nvidia-ctk runtime configure --runtime=docker && sudo systemctl restart docker
echo 'if [[ $IN_DOCKER ]]; then PS1="\[\e[0;31m\][docker]\[\e[m\] $PS1"; fi' >> ~/.bashrc
```

## Build
```bash
export BASE_IMAGE=${BASE_IMAGE:-ubuntu:24.04}
export TARGET="vim" 
docker build --build-arg "BASE_IMAGE=$BASE_IMAGE" -t "$TARGET":latest -f "$TARGET.Dockerfile" .
sed -i '/^alias z=/d' ~/.bashrc && echo "alias z='docker exec -it $TARGET bash -c \"cd \"\$PWD\" && bash -l\"'" >> ~/.bashrc
```

## Run
```bash
# For podman commands, modify with the following flags
# podman run [..] -userns=keep-id --privileged [image]

export TARGET="vim" 
docker container rm "$TARGET" --force
docker run --restart=always --name "$TARGET" -d --network=host --user $(id -u):$(id -g) \
    $(if command -v nvidia-smi &> /dev/null; then echo "--gpus all"; fi) \
    -v "/etc/group:/etc/group:ro" -v "/etc/passwd:/etc/passwd:ro" -v /home/$USER:/home/$USER \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --env="DISPLAY=$DISPLAY" \
    "$TARGET:latest"
```
