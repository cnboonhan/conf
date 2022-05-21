from __future__ import print_function, unicode_literals
from pathlib import Path
import subprocess
import os

path = os.path.abspath(__file__)
dir_path = os.path.dirname(path)
all_scripts = list(map(str, Path(f"{dir_path}/scripts").rglob('[!_]*.py')))