import os
import sys
from rich import print
from enum import Enum, auto


class SecretMgr:
    """Accessor to secrets.   A single method provides the keys"""

    rich_color = "italic red3"

    def __init__(self):
        """If any secret is missing, abort with appropriate messages"""
        self.ssh_key = self.__get_ssh_key__()
        self.linode_root_pass = self.__get_env_var__("LINODE_ROOT_PASSWORD", "with the linode root password")
        self.linode_cli_token = self.__get_env_var__("LINODE_CLI_TOKEN", "with api token from Linode Cloud Manager")
        self.all_secrets_found = self.ssh_key and self.linode_root_pass and self.linode_cli_token
        if not self.all_secrets_found:
            sys.exit(2)

    def __get_env_var__(self, env_var_name, msg):
        env_var = os.getenv(env_var_name)
        if env_var is None:
            print(f"[{SecretMgr.rich_color}]Please set env var {env_var_name} {msg}[/{SecretMgr.rich_color}]")
        return env_var

    def __get_ssh_key__(self):
        home = os.getenv("HOME")
        public_key_file = f"{home}/.ssh/id_rsa.pub"
        try:
            with open(public_key_file) as f:
                ssh_rsa_public_key = f.read()
        except:
            print(
                f"[{SecretMgr.rich_color}]Please create {public_key_file} by running ssh-keygen and accepting defaults[/{SecretMgr.rich_color}]"
            )
            return None
        else:
            return ssh_rsa_public_key.rstrip()

    def get_keys(self):
        return self.linode_root_pass, self.ssh_key


class LogLevel(str, Enum):
    DEBUG = "DEBUG"
    INFO = "INFO"
    WARNING = "WARNING"
    ERROR = "ERROR"
    CRITICAL = "CRITICAL"

    def get_help_msg():
        return "Log only messages at or below this level"
