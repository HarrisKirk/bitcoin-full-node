#!/usr/bin/env python
"""
Common functions related to spawning processes and parsing returned json
"""
import subprocess
import json
import logging


def execute_cli(cmd):
    logging.debug(" ".join(cmd))
    completed_process = subprocess.run(cmd, cwd=".", check=True, shell=False, capture_output=True)
    json_string = completed_process.stdout.decode()
    if json_string == "":
        return None
    else:
        json_object = json.loads(json_string)
        logging.debug(json.dumps(json_object, indent=2))
        return json_object


def execute_ssh(linode_ip, user, remote_cmd):
    cmd = ["ssh", "-o", "StrictHostKeyChecking=no", f"{user}@{linode_ip}"] + remote_cmd
    logging.debug(" ".join(cmd))
    completed_process = subprocess.run(cmd, cwd=".", check=True, shell=False, capture_output=True)
    return completed_process.stdout.decode()


def execute_scp(remote_cmd):
    cmd = ["scp", "-o", "StrictHostKeyChecking=no"] + remote_cmd
    logging.debug(" ".join(cmd))
    completed_process = subprocess.run(cmd, cwd=".", check=True, shell=False, capture_output=True)


def execute_sh(cmd):
    logging.debug(" ".join(cmd))    
    p = subprocess.run(cmd, check=True, shell=True, capture_output=True)
    return p.stdout.decode().rstrip()
