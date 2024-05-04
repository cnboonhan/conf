FROM ubuntu:latest

ENV SSHD_PORT=8822
ENV EDITOR=nvim
ENV PATH="${PATH}:/root/go/bin"

COPY misc/authorized_keys /root/.ssh/authorized_keys 
COPY misc/bashrc /root/.bashrc
COPY vim/init.lua /root/.config/nvim/init.lua
COPY vim/portable-vim.py /opt/portable-vim.py

RUN chmod 400 /root/.ssh/authorized_keys

RUN apt update && apt install -y \
	tmux curl openssh-server git iproute2 dnsutils openssl bash-completion gh unzip \
	shellcheck ripgrep python3 python3-pip build-essential jq
RUN ssh-keygen -b 2048 -t rsa -f /root/.ssh/id_rsa -q -N "" && mkdir /run/sshd

RUN curl -L "https://go.dev/dl/$(curl -s "https://go.dev/dl/?mode=json" | jq -r '.[0].version').linux-amd64.tar.gz" --output /root/go.tar.gz && \
    tar -xf /root/go.tar.gz -C /root && rm /root/go.tar.gz

RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh -o /tmp/get-nvm.bash
RUN bash /tmp/get-nvm.bash && /bin/bash -c ". /root/.nvm/nvm.sh && nvm install --lts && nvm use --lts"
RUN curl -L --output nvim.appimage https://github.com/neovim/neovim/releases/latest/download/nvim.appimage && \
    chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract && rm nvim.appimage && \
    mv squashfs-root /opt/nvim && ln -s /opt/nvim/AppRun /usr/bin/nvim && \
    /bin/bash -c ". /root/.nvm/nvm.sh && nvim +'LspInstall gopls bashls yamlls pyright jsonls' +qa && nvim --headless +UpdateRemotePlugins +qa";
 
RUN curl -sSL https://raw.githubusercontent.com/aandrew-me/tgpt/main/install | bash -s /usr/local/bin

WORKDIR /root

CMD ["bash", "-c", "/usr/sbin/sshd -D -o ListenAddress=0.0.0.0 -o GatewayPorts=yes -o PermitRootLogin=yes -p ${SSHD_PORT} || sleep infinity"]
