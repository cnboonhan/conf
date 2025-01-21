ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

RUN apt update && apt install curl git sudo cmake wget build-essential bash-completion black fzf gh ripgrep xclip unzip tmux ttyd python3-venv python3-pip graphviz -y

ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=20.12.0
ENV SHELL=bash
ENV TERM=xterm-256color
ENV EDITOR=nvim

# Place this line in host .bashrc for labelling: if [[ $IN_DOCKER ]]; then PS1="\[\e[0;31m\][docker]\[\e[m\] $PS1"; fi
ENV IN_DOCKER=true

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:/root/.local/share/pnpm:$PATH
RUN curl -fsSL https://get.pnpm.io/install.sh | sh -

RUN wget https://github.com/neovim/neovim/releases/download/v0.10.3/nvim-linux64.tar.gz
RUN tar -xvf nvim-linux64.tar.gz
RUN cp -r nvim-linux64/bin/* /usr/bin/
RUN cp -r nvim-linux64/lib/* /usr/lib/
RUN cp -r nvim-linux64/share/* /usr/share/
RUN rm nvim-linux64.tar.gz

RUN curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
RUN apt update 
RUN apt install wezterm timg ffmpeg -y

RUN curl -sSL https://get.docker.com/ | sh
RUN chmod u+s /usr/bin/docker

# ENV XDG_CONFIG_HOME=/root/.config
# ENV XDG_DATA_HOME=/root/.local/share
RUN chmod -R o+rwx /root
RUN chmod -R o+w /usr/local/bin

CMD ["ttyd", "-p", "8195", "-i", "127.0.0.1", "--writable", "bash"]
