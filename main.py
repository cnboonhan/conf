#!/usr/bin/env python3

# Main start of execution path for scripts
# Make sure this file is in the repository root.

from common import _load_venv 
import pathlib

if __name__ == '__main__':
    _load_venv(pathlib.Path(__file__).parent.resolve() / ".venv")