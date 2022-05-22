import subprocess
import sys
import pathlib
from typing import List
import os
import code
import readline
import rlcompleter
import signal


def _run_command(cmd: str, capture_output: bool = False, stdin=None, stdout=None, stderr=None, check_returncode: bool = True) -> str:
    signal.signal(signal.SIGINT, lambda x, y: x)
    resp = subprocess.run(
        cmd.split(), capture_output=capture_output, stdout=stdout, stderr=stderr)
    if check_returncode:
        resp.check_returncode()
    if capture_output:
        return resp.stdout.decode()
    else:
        return ''


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


def _delete_last_lines(file_path: pathlib.Path, s: int = -1):
    fd = open(file_path, "r")
    d = fd.read()
    fd.close()
    m = d.split("\n")
    s = "\n".join(m[:s])
    print(s)
    fd = open(file_path, "w+")
    for i in range(len(s)):
        fd.write(s[i])
    fd.close()


def _decrypt_folders(encrypt_folder: pathlib.Path, decrypt_folder: pathlib.Path):
    _run_command(f"fusermount -u {decrypt_folder}",
                 capture_output=False, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check_returncode=False)
    _run_command(f"gocryptfs {encrypt_folder} {decrypt_folder}", capture_output=False)
