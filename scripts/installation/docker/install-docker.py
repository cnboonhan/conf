#!/usr/bin/env python
from common import _in_virtualenv, _run_command
import pathlib
import os

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
username = os.getlogin()
docker_url = 'https://get.docker.com'
docker_tmp_path = '/tmp/get-docker.sh'

_run_command(f"curl -fsSL {docker_url} -o {docker_tmp_path}")
_run_command(f"bash {docker_tmp_path}")
_run_command(f"sudo usermod -aG docker {username}")
