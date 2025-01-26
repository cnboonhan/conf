ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

RUN apt update && apt install -y \
    curl \
    git \
    sudo \
    cmake \
    wget \
    build-essential \
    bash-completion \
    black \
    fzf \
    gh \
    jq \
    ripgrep \
    xclip \
    unzip \
    tmux \
    ttyd \
    python3-venv \
    python3-pip \
    graphviz \
    inotify-tools

ENV NVM_DIR=/root/.nvm
ENV SHELL=bash
ENV TERM=xterm-256color
ENV EDITOR=nvim

# Place this line in host .bashrc for labelling: if [[ $IN_DOCKER ]]; then PS1="\[\e[0;31m\][docker]\[\e[m\] $PS1"; fi
ENV IN_DOCKER=true

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -rc '.tag_name')/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install --lts \
    && nvm alias default lts/* \
    && nvm use default \
    && ln -s $NVM_DIR/versions/node/$(nvm current)/bin/node /usr/local/bin/node \
    && ln -s $NVM_DIR/versions/node/$(nvm current)/bin/npm /usr/local/bin/npm

RUN wget https://github.com/neovim/neovim/releases/download/$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -rc '.tag_name')/nvim-linux64.tar.gz
RUN tar -xvf nvim-linux64.tar.gz
RUN cp -r nvim-linux64/bin/* /usr/bin/
RUN cp -r nvim-linux64/lib/* /usr/lib/
RUN cp -r nvim-linux64/share/* /usr/share/
RUN rm nvim-linux64.tar.gz

RUN curl -sSL https://get.docker.com/ | sh
RUN chmod u+s /usr/bin/docker

RUN chmod -R o+rwx /root
RUN chmod -R o+w /usr/local/bin

CMD ["ttyd", "-p", "8195", "-i", "127.0.0.1", "--writable", "bash"]
