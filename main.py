#!/usr/bin/env python3

# Main start of execution path for scripts
# Make sure this file is in the repository root, and requirements.txt as well
# There should be a folder scripts with more python script files, and 
# There should be a folder configs with .conf files

import pathlib
from common import _in_virtualenv, _install_pip_dependencies
assert _in_virtualenv(), "Please source [path to repo]/.venv/bin/activate."
_install_pip_dependencies(pathlib.Path(__file__).parent.resolve() / "requirements.txt")

import os

if __name__ == '__main__':
    pass