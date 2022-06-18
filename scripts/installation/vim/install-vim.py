#!/usr/bin/env python
from common import _in_virtualenv, _install_dependencies, _create_conf_symlink, _run_command
import pathlib
import os

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
vim_plug_url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

_install_dependencies(['vim-gtk3', 'curl', 'exuberant-ctags',
                      'ripgrep', 'shellcheck', 'flake8', 'python3-autopep8'])

_run_command(f"curl -fLo {home_path}/.vim/autoload/plug.vim --create-dirs {vim_plug_url}")

_create_conf_symlink(dir_path / '.vimrc', home_path / '.vimrc')

_run_command('vim -c PlugClean! -c qall!')
_run_command('vim -c PlugInstall -c qall!')

# CocInstall coc-pyright coc-json coc-go
