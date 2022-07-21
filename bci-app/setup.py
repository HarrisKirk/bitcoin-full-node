import os
from rich import print

class SecretMgr:
    """Accessor to secrets.   A single method provides the keys"""

    def __init__(self):
        """If any secret is missing, raise the appropriate exception"""
        self.linode_root_pass = self.__get_linode_root_pass__()
        self.ssh_key = self.__get_ssh_key__()
        self.__verify_cli_api_key__()  # verified but not accessed (used only by subprocess)

    def __get_linode_root_pass__(self):
        pw = os.getenv("LINODE_ROOT_PASSWORD")
        if pw is None:
            print("[italic red3]Please set env var LINODE_ROOT_PASSWORD env variable with the root password[/italic red3]")
            raise SystemExit(2)
        return pw

    def __get_ssh_key__(self):
        home = os.getenv("HOME")
        public_key_file = f"{home}/.ssh/id_rsa.pub"
        try:
            with open(public_key_file) as f:
                ssh_rsa_public_key = f.read()
        except:
            print(f"[italic red3]Please create {public_key_file} by running ssh-keygen[/italic red3]")
            raise SystemExit(2)
        else:
            return ssh_rsa_public_key

    def __verify_cli_api_key__(self):
        api_key = os.getenv("LINODE_CLI_TOKEN")
        if api_key is None:
            print("[italic red3]Please set env var LINODE_CLI_TOKEN env variable with api token from Linode Cloud Manager[/italic red3]")
            raise SystemExit(2)
        return 

    def get_keys(self):
        return self.linode_root_pass, self.ssh_key

        