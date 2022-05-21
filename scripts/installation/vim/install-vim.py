#!/usr/bin/env python
from common import _in_virtualenv, _install_dependencies, _create_conf_symlink
import pathlib
import os
import subprocess

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_install_dependencies(['vim-gtk3', 'curl', 'exuberant-ctags', 'ripgrep'])
subprocess.run(f"curl -fLo {home_path}/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim".split(
)).check_returncode()

_create_conf_symlink(dir_path / '.vimrc', home_path / '.vimrc')

subprocess.run('vim -c PlugInstall -c qall!'.split()).check_returncode()