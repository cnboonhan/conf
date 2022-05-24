import pathlib
from botocore.config import Config
from dotenv import dotenv_values, load_dotenv
from common import _run_command
import boto3
import os
from prompts import prompt_choice


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
        kwargs = {'config': self.boto_config,
                  'aws_access_key_id': self.config["AWS_ACCESS_KEY_ID"],
                  'aws_secret_access_key': self.config["AWS_SECRET_ACCESS_KEY"],
                  'aws_session_token': self.config["AWS_SESSION_TOKEN"]}

        self.s3 = boto3.client('s3', **kwargs)
        self.ec2 = boto3.client('ec2', **kwargs)
        self.acm = boto3.client('acm', **kwargs)
        self.apigateway = boto3.client('apigateway', **kwargs)
        self.autoscaling = boto3.client('autoscaling', **kwargs)
        self.cloudformation = boto3.client('cloudformation', **kwargs)
        self.cloudwatch = boto3.client('cloudwatch', **kwargs)
        self.ebs = boto3.client('ebs', **kwargs)
        self.iam = boto3.client('iam', **kwargs)
        self.imagebuilder = boto3.client('imagebuilder', **kwargs)
        self.kms = boto3.client('kms', **kwargs)
        self.rds = boto3.client('rds', **kwargs)
        self.route53 = boto3.client('route53', **kwargs)
        self.sns = boto3.client('sns', **kwargs)
        self.ssm = boto3.client('ssm', **kwargs)
        self.sts = boto3.client('sts', **kwargs)

        os.environ['AWS_ACCESS_KEY_ID'] = kwargs['aws_access_key_id']
        os.environ['AWS_SECRET_ACCESS_KEY'] = kwargs['aws_secret_access_key']
        os.environ['AWS_SESSION_TOKEN'] = kwargs['aws_session_token']
        os.environ['AWS_DEFAULT_REGION'] = self.config['AWS_DEFAULT_REGION']

    def ssm_connect(self, instance_id: str = '') -> None:
        if not instance_id:
            response = self.ec2.describe_instances(
                Filters=[
                    {
                        'Name': 'instance-state-name',
                        'Values': ['running'],
                    },
                ],
            )

            data = {}
            for r in response['Reservations']:
                for i in r['Instances']:
                    instance_id = i['InstanceId']
                    try:
                        tags = i['Tags']
                    except KeyError:
                        tags = []
                    info = f"InstanceID: {id}\nTags: {tags}"
                    data[instance_id] = info

            i = prompt_choice([i for i in data.items()],
                              "EC2", "Select EC2 to connect to.")

        if instance_id:
            _run_command(f"aws ssm start-session --target {instance_id}")
