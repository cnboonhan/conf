import gitlab
from dotenv import dotenv_values, load_dotenv
from common import _in_virtualenv
import pathlib
import requests

assert _in_virtualenv(), 'Please source [path to repo]/.venv/bin/activate.'

def setup_gitlab(dotenv_path: pathlib.Path):
    config = dotenv_values(dotenv_path)
    load_dotenv(dotenv_path)

    REQUIRED_KEYS = ["GITLAB_URL", "GITLAB_AUTH_TOKEN"]
    assert all(key in config.keys() for key in REQUIRED_KEYS)

    session = requests.Session()

    if config.get("HTTP_PROXY_URL"):
        session.proxies = {
            "http": config["HTTP_PROXY_URL"],
            "https": config["HTTP_PROXY_URL"],
        }

    gl = gitlab.Gitlab(config["GITLAB_URL"],
                       config["GITLAB_AUTH_TOKEN"],
                       session=session,
                       ssl_verify=False)

    return gl
