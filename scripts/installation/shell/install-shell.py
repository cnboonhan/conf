#!/usr/bin/env python
from common import _in_virtualenv, _create_conf_symlink, _install_dependencies
import pathlib
import os

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_install_dependencies(['netcat'])
_create_conf_symlink(dir_path / '.bashrc', home_path / '.bashrc')