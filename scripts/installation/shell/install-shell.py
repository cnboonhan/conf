#!/usr/bin/env python
from common import _in_virtualenv, _create_conf_symlink, _install_dependencies, _create_encrypt_folder, _decrypt_folders, _run_command
import pathlib
import os
import shutil

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_install_dependencies(['netcat', 'gocryptfs', 'xclip'])

if not shutil.which('google-chrome'):
    _run_command("wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/gc.deb") 
    _run_command("sudo dpkg -i /tmp/gc.deb")

if not os.path.isdir(home_path / '.encrypt'):
    print("Creating encrypted directory as it does not exist")
    _create_encrypt_folder(home_path / '.encrypt')

os.makedirs(home_path / '.decrypt', exist_ok=True)
_decrypt_folders(home_path / '.encrypt', home_path / '.decrypt')

os.makedirs(home_path / '.ssh', exist_ok=True)
os.makedirs(home_path / '.decrypt/.ssh', exist_ok=True)
_create_conf_symlink(dir_path / '.bashrc', home_path / '.bashrc')
_create_conf_symlink(dir_path / 'ssh_config', home_path / '.ssh/config')
_create_conf_symlink(dir_path / '.ignore', home_path / '.ignore')
