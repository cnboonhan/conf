import os
import shutil
import tarfile

WORKING_PATH = '/tmp/portable-vim'
if os.path.isdir(WORKING_PATH):
    shutil.rmtree(WORKING_PATH)
os.makedirs(WORKING_PATH, exist_ok=True)
os.chdir(WORKING_PATH)


os.makedirs('.local/share', exist_ok=True)
os.makedirs('.config', exist_ok=True)

with open("/tmp/fix-symlinks.bash", "w") as text_file:
    text_file.write('#!/bin/bash\n')
    text_file.write('cd "$HOME/.local/share/nvim/mason/bin"\n')
    text_file.write('for link in $(ls | xargs -I{} readlink {}); do bin=$(basename $link); rm "$bin"; ln -s $(find $HOME/.local/share/nvim/mason/packages -name "$bin" | grep "node_modules/.bin"); done\n')
    text_file.write('export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"\n')
    text_file.write('[ -s "$NVM_DIR/nvm.sh" ] && \\. "$NVM_DIR/nvm.sh"\n')

shutil.copytree(f"/opt/nvim", 'nvim')
shutil.copyfile(f"/tmp/fix-symlinks.bash", 'fix-symlinks.bash')
shutil.copytree(f"{os.path.expanduser('~')}/.local/share/nvim", '.local/share/nvim', symlinks=True)
shutil.copytree(f"{os.path.expanduser('~')}/.config/nvim", '.config/nvim', symlinks=True)
shutil.copytree(f"{os.path.expanduser('~')}/.nvm", '.nvm', symlinks=True)

with tarfile.open("/tmp/portable-vim.tar", mode="w:gz") as tar_file:
  os.chdir("/tmp/portable-vim")
  tar_file.add(".", recursive=True)

print("Saved to /tmp/portable-vim.tar")
