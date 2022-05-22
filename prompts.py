from __future__ import print_function, unicode_literals
import pathlib
import os
import sys
import subprocess
from prompt_toolkit.shortcuts import radiolist_dialog

script_path = pathlib.Path(__file__).parent.resolve() / "scripts"


def _prompt_category() -> str:
    script_categories = script_path.glob('[!_]*')
    category = radiolist_dialog(
        values=[(s, os.path.basename(s)) for s in script_categories],
        title="Category",
        text="Select Script Category.",
    ).run()

    if not category:
        sys.exit(0)

    return category


def prompt_task() -> None:
    category = _prompt_category()

    all_scripts = list(map(str, (script_path / category).rglob('[!_]*.py')))
    run_script = radiolist_dialog(
        values=[(s, os.path.basename(s)) for s in all_scripts],
        title="Scripts",
        text="Select Script to Run.",
    ).run()

    if run_script:
        subprocess.run(f"python3 {run_script}".split()).check_returncode()
    else:
        sys.exit(0)
