#!/usr/bin/env python3

# Minimal script to pull the main repository.

import subprocess
import lsb_release
import venv
import sys
import os
import pathlib
from typing import List

def _install_dependencies(deps: List[str]) -> None:
    match lsb_release.get_distro_information()['ID']:
        case 'Ubuntu':
            p = subprocess.run('sudo apt install -y'.split() + deps)
        case _:
            raise Exception("Unrecognized OS. Terminating..")

def _create_venv(path: str) -> None:
    pathlib.Path(path).mkdir(parents=True, exist_ok=True)
    _install_dependencies(['python3-venv'])
    venv.create(path, with_pip=True, system_site_packages=True)

def _get_core_repository(path: str) -> None:
    subprocess.run(f"git clone https://github.com/cnboonhan/conf {path}".split())

if __name__ == '__main__':
    path = pathlib.Path(os.path.expanduser('~'))
    _install_dependencies(['git'])
    _get_core_repository(path / ".conf")
    _create_venv(path / ".conf/.venv")