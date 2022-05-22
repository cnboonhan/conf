#!/usr/bin/env python
from common import _in_virtualenv, _install_pip_dependencies, _install_dependencies
import pathlib
import subprocess
import os
import shutil

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))

_install_pip_dependencies(dir_path / 'requirements.txt')
_install_dependencies(['python3-tk', 'jq', 'unzip'])

if os.path.exists('/tmp/aws'):
    shutil.rmtree('/tmp/aws')

if os.path.exists('/tmp/awscliv2.zip'):
    os.remove('/tmp/awscliv2.zip')

subprocess.run(
    "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o /tmp/awscliv2.zip".split()
).check_returncode()

subprocess.run("unzip /tmp/awscliv2.zip -d /tmp".split()).check_returncode()

subprocess.run("sudo /tmp/aws/install".split()).check_returncode()

subprocess.run(
    "curl https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb \
            -o /tmp/session-manager-plugin.deb".split()
).check_returncode()

subprocess.run(
    "sudo dpkg -i /tmp/session-manager-plugin.deb".split()
).check_returncode()
