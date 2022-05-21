from _gitlab import setup_gitlab
from common import _be_interactive

if __name__ == '__main__':
    gl = setup_gitlab()
    _be_interactive(locals())