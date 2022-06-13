#!/usr/bin/env python
from common import _in_virtualenv, _install_pip_dependencies, _install_dependencies, _run_command
import pathlib
import os
import shutil

assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
aws_path = '/tmp/aws'
aws_zip_path = '/tmp/awscliv2.zip'
aws_url = "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
ssm_deb_url = "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb"
ssm_deb_path = "/tmp/session-manager-plugin.deb"

_install_pip_dependencies(dir_path / 'requirements-devops.txt')
_install_dependencies(['python3-tk', 'jq', 'unzip'])

if os.path.exists(aws_path):
    shutil.rmtree(aws_path)

if os.path.exists(aws_zip_path):
    os.remove(aws_zip_path)

_run_command(f"curl {aws_url}  -o {aws_zip_path}")
_run_command(f"unzip {aws_zip_path} -d /tmp")
_run_command(f"sudo {aws_path}/install --update")

_run_command(f"curl {ssm_deb_url} -o {ssm_deb_path}")
_run_command(f"sudo dpkg -i {ssm_deb_path}")
