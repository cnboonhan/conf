#!/usr/bin/env python
from common import _in_virtualenv, _install_pip_dependencies, _install_dependencies
import pathlib
import subprocess
import os

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_install_pip_dependencies(dir_path / 'requirements.txt')
_install_dependencies(['python3-tk'])
subprocess.run(
    "curl https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb \
            -o /tmp/session-manager-plugin.deb".split()
).check_returncode()

subprocess.run(
    "sudo dpkg -i /tmp/session-manager-plugin.deb".split()
).check_returncode()
