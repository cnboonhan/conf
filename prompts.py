from __future__ import print_function, unicode_literals
import pathlib
import os
import sys
import subprocess
from prompt_toolkit.shortcuts import radiolist_dialog

script_path = pathlib.Path(__file__).parent.resolve() / "scripts"

def _prompt_category() -> int:
    script_categories = script_path.glob('[!_]*')
    category = radiolist_dialog(
        values=[(s, os.path.basename(s)) for s in script_categories],
        title="Category",
        text="Select Script Category.",
    ).run()
    return category

def prompt_task() -> int:
    category = _prompt_category()
    all_scripts = list(map(str, (script_path / category).rglob('[!_]*.py')))
    run_script = radiolist_dialog(
        values=[(s, os.path.basename(s)) for s in all_scripts],
        title="Scripts",
        text="Select Script to Run.",
    ).run()

    if run_script:
        return subprocess.run(f"python3 {run_script}".split()).returncode
    else:
        sys.exit(0)