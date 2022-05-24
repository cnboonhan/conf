#!/usr/bin/env python3

# Main start of execution path for scripts
# Make sure this file is in the repository root, and requirements.txt as well
# There should be a folder scripts with more python script files, and
# There should be a folder configs with .conf files

import pathlib
import time
import os
from common import _in_virtualenv, _install_pip_dependencies
assert _in_virtualenv(), 'Please source [path to repo]/.venv/bin/activate.'
dir_path = pathlib.Path(__file__).parent.resolve()
_install_pip_dependencies(dir_path / 'requirements.txt')

from prompts import prompt_task

if __name__ == '__main__':
    os.environ["PYTHONPATH"] = str(dir_path)
    while True:
        task_failed = prompt_task()
        assert not task_failed, f"Something went wrong with selected task. returncode: {task_failed}"
        print("Done.")
        time.sleep(0.5)
