#!/usr/bin/env python
from common import _in_virtualenv, _install_dependencies
import pathlib
import os
import subprocess

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_install_dependencies(['tmux'])

try:
    os.remove(home_path / '.tmux.conf')
except Exception:
    pass

os.symlink(dir_path / '.tmux.conf', home_path / '.tmux.conf')