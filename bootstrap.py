#!/usr/bin/env python3

# Minimal script to pull the main repository.

import subprocess
import lsb_release
import sys
import os
from typing import List

def _install_dependencies(deps: List[str]) -> None:
    match lsb_release.get_distro_information()['ID']:
        case 'Ubuntu':
            p = subprocess.run('sudo apt install -y'.split() + deps)
        case _:
            raise Exception("Unrecognized OS. Terminating..")
            sys.exit(1)

def _get_core_repository(path: str = os.path.expanduser('~')):
    subprocess.run(f"git clone https://github.com/cnboonhan/conf {path}/.conf".split())

if __name__ == '__main__':
    _install_dependencies(['git'])
    _get_core_repository()
