#!/usr/bin/env python
from common import _in_virtualenv
import pathlib
import os
import subprocess
import shutil

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

shutil.copy(home_path / '.bashrc', '/tmp/.bashrc')

subprocess.run(
    'wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh'
    .split(),
    stdout=open('/tmp/install.sh', 'w')).check_returncode()

subprocess.run('bash /tmp/install.sh'.split()).check_returncode()
shutil.move('/tmp/.bashrc', home_path / '.bashrc')
