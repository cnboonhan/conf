FROM ubuntu:24.04

RUN apt update && apt install curl git sudo cmake wget build-essential black fzf gh ripgrep xclip -y

ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=20.12.0

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN wget https://github.com/neovim/neovim/releases/download/v0.10.3/nvim-linux64.tar.gz
RUN tar -xvf nvim-linux64.tar.gz
RUN cp -r nvim-linux64/bin/* /usr/bin/
RUN cp -r nvim-linux64/lib/* /usr/lib/
RUN cp -r nvim-linux64/share/* /usr/share/
RUN rm nvim-linux64.tar.gz

# ENV XDG_CONFIG_HOME=/root/.config
# ENV XDG_DATA_HOME=/root/.local/share
RUN chmod -R o+rwx /root

CMD ["sleep", "infinity"]
