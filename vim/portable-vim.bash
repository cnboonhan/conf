#!/bin/bash
WORKING_PATH='/tmp/portable-vim'

[[ -d "$WORKING_PATH" ]] && rm -rf "$WORKING_PATH"
mkdir "$WORKING_PATH"

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
echo '''
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
''' > "$WORKING_PATH/load_nvm.sh"
source "$WORKING_PATH/load_nvm.sh"
nvm install --lts
nvm use --lts

cd "$WORKING_PATH"

mkdir -p ".local/share"
mkdir -p ".config"

cp -r "$HOME/.local/share/nvim" ".local/share/nvim"
cp -r "$HOME/.config/nvim" ".config/nvim"
cp -r "$HOME/.nvm" ".nvm"

curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage

cd "$WORKING_PATH"
tar -cvf /tmp/nvim.tar .

echo "Saved to /tmp/nvim.tar"
