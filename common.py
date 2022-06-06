import subprocess
import sys
import pathlib
from typing import List
import os
import code
import readline
import rlcompleter
import signal
import platform
import requests


def _run_command(cmd: str, capture_output: bool = False, stdin=None, stdout=None, stderr=None, check_returncode: bool = True, shell=False) -> str:
    signal.signal(signal.SIGINT, lambda x, _: x)
    resp = subprocess.run(
        cmd.split(), capture_output=capture_output, stdin=stdin, stdout=stdout, stderr=stderr, shell=shell)
    if check_returncode:
        resp.check_returncode()
    if capture_output:
        return resp.stdout.decode()
    else:
        return ''

def _download_gitlab_release(user: str, repo: str):
    url = f"https://api.github.com/repos/{user}/{repo}/releases/latest" 
    r = requests.get(url)
    assets = r.json()['assets']
    for asset in assets:
        browser_url = asset['browser_download_url'].lower()
        if platform.processor().lower() in browser_url:
            if platform.system().lower() in browser_url:
                d = requests.get(browser_url)
                filename = browser_url.split('/')[-1]
                open(f"/tmp/{filename}", 'wb').write(r.content)
                return filename

def _dependency_not_installed(dep: str) -> bool:
    resp = 'installed' in _run_command(
        f"apt list {dep} -qq", capture_output=True)
    return not bool(resp)


def _install_dependencies(deps: List[str]) -> None:
    import lsb_release
    match lsb_release.get_distro_information()['ID']:
        case 'Ubuntu':
            ds = list(filter(_dependency_not_installed, deps))
            if ds:
                _run_command(f"sudo apt -qqq install -y {' '.join(ds)}")
        case _:
            raise Exception('Unrecognized OS. Terminating..')


def _get_base_prefix_compat():
    """Get base/real prefix, or sys.prefix if there is none."""
    return getattr(sys, "base_prefix", None) or getattr(sys, "real_prefix", None) or sys.prefix


def _in_virtualenv():
    return _get_base_prefix_compat() != sys.prefix


def _install_pip_dependencies(path: pathlib.Path) -> None:
    assert _in_virtualenv(), 'Please source [path to repo]/.venv/bin/activate.'
    _run_command(f"pip3 install -q -r {path}")


def _be_interactive(loc: dict):
    vars = globals()
    vars.update(loc)
    readline.set_completer(rlcompleter.Completer(vars).complete)
    readline.parse_and_bind("tab: complete")
    code.InteractiveConsole(vars).interact()


def _create_conf_symlink(source_path: pathlib.Path, dest_path: pathlib.Path):

    try:
        os.remove(dest_path)
    except Exception:
        pass

    os.symlink(source_path, dest_path)


def _create_encrypt_folder(encrypt_folder: pathlib.Path):
    os.makedirs(encrypt_folder, exist_ok=True)
    _run_command(f"gocryptfs --init {encrypt_folder}")


def _decrypt_folders(encrypt_folder: pathlib.Path, decrypt_folder: pathlib.Path):
    _run_command(f"fusermount -u {decrypt_folder}",
                 capture_output=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check_returncode=False)
    _run_command(f"gocryptfs {encrypt_folder} {decrypt_folder}", capture_output=False)
