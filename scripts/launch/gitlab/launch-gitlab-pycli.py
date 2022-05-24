from gitlab_wrapper import setup_gitlab
from common import _be_interactive
import pathlib
import os

dir_path = pathlib.Path(__file__).parent.resolve()
home_path = pathlib.Path(os.path.expanduser('~'))
dotenv_path = dir_path / '.env'

if __name__ == '__main__':
    gl = setup_gitlab(dotenv_path)
    _be_interactive(locals())
