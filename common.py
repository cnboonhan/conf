import subprocess
import sys
import pathlib
from typing import List
import sys

def _dependency_not_installed(dep: str) -> bool:
    resp = 'installed' in subprocess.run(f"apt list {dep} -qq".split(), capture_output=True).stdout.decode()
    return not bool(resp)

def _install_dependencies(deps: List[str]) -> None:
    import lsb_release
    match lsb_release.get_distro_information()['ID']:
        case 'Ubuntu':
            ds = list(filter(_dependency_not_installed, deps))
            if ds:
                p = subprocess.run('sudo apt -qqq install -y'.split() + ds)
                assert p.returncode == 0, 'Something went wrong with dependency installation.'
        case _:
            raise Exception('Unrecognized OS. Terminating..')

def _get_base_prefix_compat():
    """Get base/real prefix, or sys.prefix if there is none."""
    return getattr(sys, "base_prefix", None) or getattr(sys, "real_prefix", None) or sys.prefix

def _in_virtualenv():
    return _get_base_prefix_compat() != sys.prefix

def _install_pip_dependencies(path: pathlib.Path) -> None:
    assert _in_virtualenv(), 'Please source [path to repo]/.venv/bin/activate.'
    assert subprocess.run(f"pip3 install -q -r {path}".split()).returncode == 0, 'Something went wrong with pip installation.'