from common import _in_virtualenv, _be_interactive
import pathlib
import os
from aws_wrapper import AWS

assert _in_virtualenv(), 'Please source [path to repo]/.venv/bin/activate.'
dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
dotenv_path = dir_path / '.env'


if __name__ == '__main__':
    aws = AWS(dotenv_path)
    _be_interactive(locals())
