#!/usr/bin/env python3

# Minimal script to pull the main repository.

import subprocess
import venv
import os
import pathlib


def _create_venv(path: pathlib.Path) -> None:
    pathlib.Path(path).mkdir(parents=True, exist_ok=True)
    venv.create(path, with_pip=True, system_site_packages=True)


def _get_core_repository(path: pathlib.Path) -> None:
    subprocess.run(
        f"git clone https://github.com/cnboonhan/conf {path}".split())


if __name__ == '__main__':
    subprocess.run('sudo apt update'.split())
    p = subprocess.run('sudo apt install -y git wget bash-completion python3-venv'.split())

    path = pathlib.Path(os.path.expanduser('~'))
    if not os.path.exists(path / ".conf"):
        _get_core_repository(path / ".conf")
    else:
        print(".conf folder already exists, not updating.")
    _create_venv(path / ".conf/.venv")
