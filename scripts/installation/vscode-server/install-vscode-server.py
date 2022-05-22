#!/usr/bin/env python
from common import _in_virtualenv, _run_command
import pathlib
import os

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
vscode_server_url = 'https://code-server.dev/install.sh'
script_path = '/tmp/install.sh'

_run_command(
    f"curl -fsSL {vscode_server_url}",
    stdout=open(script_path, 'w'))

_run_command(f"bash {script_path}")
