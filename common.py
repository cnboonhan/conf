import subprocess
import lsb_release
import sys
import venv
from typing import List
from pathlib import Path

def _dependency_not_installed(dep: str) -> bool:
    resp = 'installed' in subprocess.run(f"apt list {dep} -qq".split(), capture_output=True).stdout.decode()
    return not bool(resp)

def _install_dependencies(deps: List[str]) -> None:
    match lsb_release.get_distro_information()['ID']:
        case 'Ubuntu':
            ds = list(filter(_dependency_not_installed, deps))
            if ds:
                p = subprocess.run('sudo apt -qqq install -y'.split() + ds)
                assert p.returncode == 0, 'Something went wrong with dependency installation.'
        case _:
            raise Exception('Unrecognized OS. Terminating..')