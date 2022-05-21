import pathlib
from botocore.config import Config
from dotenv import dotenv_values, load_dotenv
from botocore.config import Config
import boto3


def setup_aws_config(dotenv_path: pathlib.Path):
    config = dotenv_values(dotenv_path)
    load_dotenv(dotenv_path)
    REQUIRED_KEYS = [
        "AWS_DEFAULT_REGION", "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY",
        "AWS_SESSION_TOKEN"
    ]
    assert all(key in config.keys() for key in REQUIRED_KEYS)

    proxy_definitions = None
    if config.get("HTTP_PROXY_URL"):
        proxy_definitions = {
            'https': config["HTTP_PROXY_URL"],
            'http': config["HTTP_PROXY_URL"],
        }

    boto_config = Config(region_name=config["AWS_DEFAULT_REGION"],
                         proxies=proxy_definitions)

    return config, boto_config


class AWS:

    def __init__(self, dotenv_path: pathlib.Path):
        self.config, self.boto_config = setup_aws_config(dotenv_path)
        self.s3 = boto3.client(
            's3',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.ec2 = boto3.client(
            'ec2',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.acm = boto3.client(
            'acm',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.apigateway = boto3.client(
            'apigateway',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.autoscaling = boto3.client(
            'autoscaling',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.cloudformation = boto3.client(
            'cloudformation',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.cloudwatch = boto3.client(
            'cloudwatch',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.ebs = boto3.client(
            'ebs',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.iam = boto3.client(
            'iam',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.imagebuilder = boto3.client(
            'imagebuilder',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.kms = boto3.client(
            'kms',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.rds = boto3.client(
            'rds',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.route53 = boto3.client(
            'route53',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.sns = boto3.client(
            'sns',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])

        self.ssm = boto3.client(
            'ssm',
            config=self.boto_config,
            aws_access_key_id=self.config["AWS_ACCESS_KEY_ID"],
            aws_secret_access_key=self.config["AWS_SECRET_ACCESS_KEY"],
            aws_session_token=self.config["AWS_SESSION_TOKEN"])
