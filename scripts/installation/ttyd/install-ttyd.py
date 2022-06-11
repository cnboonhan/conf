#!/usr/bin/env python
from common import _in_virtualenv, _install_dependencies, _download_github_release, _run_command
import pathlib
import os
import platform

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
ttyd_path = '/usr/local/bin/ttyd'

filename = _download_github_release('docker', 'compose', [platform.processor(), platform.system()])
_run_command(f"sudo mv /tmp/{filename} {ttyd_path}")
_run_command(f"sudo chmod +x {ttyd_path}")
