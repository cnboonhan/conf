#!/usr/bin/env python
from common import _in_virtualenv, _create_conf_symlink, _install_dependencies, _create_encrypt_folder
import pathlib
import os

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_install_dependencies(['netcat', 'gocryptfs'])

if not os.path.isdir(home_path / '.encrypt'):
    print("Creating encrypted directory as it does not exist")
    _create_encrypt_folder(home_path / '.encrypt')

os.makedirs(home_path / '.ssh', exist_ok=True)
_create_conf_symlink(dir_path / '.bashrc', home_path / '.bashrc')
_create_conf_symlink(dir_path / '.gitconfig', home_path / '.gitconfig')
_create_conf_symlink(dir_path / 'ssh_config', home_path / '.ssh/config')
