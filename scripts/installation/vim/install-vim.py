#!/usr/bin/env python
from common import _in_virtualenv, _install_dependencies
import pathlib
import os
import subprocess

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()

_install_dependencies(['vim-gtk3', 'curl', 'exuberant-ctags'])
home_path = pathlib.Path(os.path.expanduser('~'))
assert not subprocess.run(f"curl -fLo {home_path}/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim".split()).returncode

try:
    os.remove(home_path / '.vimrc')
except Exception:
    pass

os.symlink(dir_path / '.vimrc', home_path / '.vimrc')

assert not subprocess.run('vim -c PlugInstall -c qall!'.split()).returncode