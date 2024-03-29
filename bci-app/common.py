"""
Common functions related to running local and remote processes 
"""
import subprocess
import json
import logging
from retry import retry


def execute_cli(cmd):
    """Run a command within the docker container.   Assume the command is a linode-cli command
    and process accordingly
    """
    logging.debug(" ".join(cmd))
    completed_process = subprocess.run(cmd, cwd=".", check=False, shell=False, capture_output=True)

    if completed_process.returncode == 0:
        json_string = completed_process.stdout.decode()
        if json_string == "":  # Use case is no linode artifacts are returned
            return None
        else:
            json_object = json.loads(json_string)
            logging.debug(json.dumps(json_object, indent=2))
            return json_object
    else:
        err_parts = completed_process.stderr.decode().split("\n")
        json_object = json.loads(err_parts[1])
        logging.exception(f"linode-cli returned stderr {json.dumps(json_object, indent=2)}")
        raise Exception()


@retry(tries=5, delay=10, logger=logging.getLogger())
def execute_ssh(linode_ip, user, remote_cmd):
    """Execute shell commend on remote linode without strict host key checking"""
    cmd = ["ssh", "-o", "StrictHostKeyChecking=no", f"{user}@{linode_ip}"] + remote_cmd
    logging.debug(" ".join(cmd))
    completed_process = subprocess.run(cmd, cwd=".", check=True, shell=False, capture_output=True)
    return completed_process.stdout.decode()


def execute_scp(remote_cmd):
    """Execute scp on remote linode without strict host key checking"""
    cmd = ["scp", "-o", "StrictHostKeyChecking=no"] + remote_cmd
    logging.debug(" ".join(cmd))
    completed_process = subprocess.run(cmd, cwd=".", check=True, shell=False, capture_output=True)


def execute_sh(cmd):
    """Execute local ssh command within the docker container"""
    logging.debug(" ".join(cmd))
    p = subprocess.run(cmd, check=True, shell=True, capture_output=True)
    return p.stdout.decode().rstrip()
