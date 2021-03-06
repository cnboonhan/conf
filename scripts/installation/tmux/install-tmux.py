#!/usr/bin/env python
from common import _in_virtualenv, _install_dependencies, _create_conf_symlink
import pathlib
import os

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_install_dependencies(['tmux'])
_create_conf_symlink(dir_path / '.tmux.conf', home_path / '.tmux.conf')