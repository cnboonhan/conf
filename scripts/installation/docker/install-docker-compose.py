#!/usr/bin/env python
from common import _in_virtualenv, _download_github_release, _run_command
import pathlib
import os

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
docker_compose_path = pathlib.Path('/usr/local/bin/docker-compose')

filename = _download_github_release('docker', 'compose')
_run_command(f"sudo mv /tmp/{filename} /usr/local/bin/docker-compose")
_run_command(f"sudo chmod +x {docker_compose_path}")
