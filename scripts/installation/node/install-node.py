#!/usr/bin/env python
from common import _in_virtualenv, _run_command
import pathlib
import os
import subprocess

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
home_bashrc_path = home_path / '.bashrc'
tmp_bashrc_path = '/tmp/.bashrc'
install_script_path = '/tmp/install.sh'
nvm_url = "https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh"

if os.path.exists(tmp_bashrc_path):
    os.remove(tmp_bashrc_path)
os.rename(home_bashrc_path, tmp_bashrc_path)

_run_command(f"wget -qO- {nvm_url}",
             stdout=open(install_script_path, 'w'))
os.rename(tmp_bashrc_path, home_bashrc_path)

_run_command(f"bash {install_script_path}")

subprocess.run(['/bin/bash', '-i', '-c', 'nvm install --lts'])

