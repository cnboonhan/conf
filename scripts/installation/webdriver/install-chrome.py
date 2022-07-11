#!/usr/bin/env python
from common import _in_virtualenv, _install_pip_dependencies, _run_command
import pathlib
import os
import shutil

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_run_command("wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/gc.deb") 
_run_command("sudo apt install /tmp/gc.deb -y")
