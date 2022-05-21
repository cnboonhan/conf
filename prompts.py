from __future__ import print_function, unicode_literals
import pathlib
import os
import sys
import subprocess
from prompt_toolkit.shortcuts import radiolist_dialog

dir_path = pathlib.Path(__file__).parent.resolve()
all_scripts = list(map(str, pathlib.Path(f"{dir_path}/scripts").rglob('[!_]*.py')))

def prompt_task() -> int:
    run_script = radiolist_dialog(
        values=[(s, os.path.basename(s)) for s in all_scripts],
        title="Scripts",
        text="Select Script to Run.",
    ).run()

    if run_script:
        return subprocess.run(f"python3 {run_script}".split()).returncode
    else:
        sys.exit(0)