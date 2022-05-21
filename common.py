import subprocess
import lsb_release
import sys
import venv
from typing import List
from pathlib import Path

def _dependency_not_installed(dep: str) -> bool:
    resp = "installed" in subprocess.run(f"apt list {dep} -qq".split(), capture_output=True).stdout.decode()
    return not bool(resp)

def _install_dependencies(deps: List[str]) -> None:
    match lsb_release.get_distro_information()['ID']:
        case 'Ubuntu':
            ds = list(filter(_dependency_not_installed, deps))
            if ds:
                p = subprocess.run('sudo apt -qqq install -y'.split() + ds)
                assert p.returncode == 0, "Something went wrong with dependency installation."
        case _:
            raise Exception("Unrecognized OS. Terminating..")

def _load_venv(path: str) -> None:
    Path(path).mkdir(parents=True, exist_ok=True)
    if sys.prefix == sys.base_prefix:
        _install_dependencies(["python3-venv"])
        venv.create(path, with_pip=True, system_site_packages=True)
    else:
        print("Already in Virtual Environment.")