"""
Functions that install and launch a bitcoin full node.   Assumes the cloud infrastructure is in place.
"""
from common import execute_ssh, execute_scp
import logging
import json


def launch_bitcoind(linode_ip, chain, vol_label):
    """Configure user and permissions for bitcoin"""
    logging.info(f"Launching bitcoind with chain={chain} and datadir=/mnt/{vol_label}")
    execute_ssh(linode_ip, "root", ["chmod", "-R", "770", f"/mnt/{vol_label}"])
    execute_ssh(linode_ip, "root", ["useradd", "-m", "--shell", "/bin/bash", "bitcoinuser"])
    execute_ssh(linode_ip, "root", ["chown", "bitcoinuser:bitcoinuser", "-R", f"/mnt/{vol_label}"])
    execute_scp(["/opt/devops-bci/startnode.sh", f"root@{linode_ip}:/home/bitcoinuser"])
    execute_ssh(linode_ip, "root", ["chown", "bitcoinuser:bitcoinuser", "-R", f"/home/bitcoinuser/startnode.sh"])
    console_out = execute_ssh(
        linode_ip,
        "root",
        ["-t", "sudo", "-u", "bitcoinuser", f"/home/bitcoinuser/startnode.sh", chain, f"/mnt/{vol_label}"],
    )
    logging.debug(console_out)
    logging.info("Bitcoin node running.")


def get_blockchain_info(linode_ip):
    console_out = execute_ssh(
        linode_ip,
        "root",
        [
            "-t",
            "sudo",
            "-u",
            "bitcoinuser",
            f"/home/bitcoinuser/bitcoin_core/bitcoin-23.0/bin/bitcoin-cli",
            "getblockchaininfo",
        ],
    )
    logging.debug(f"json from bitcoin-cli: {console_out}")
    json_object = json.loads(console_out)
    ibl = json_object["initialblockdownload"]
    sod = json_object["size_on_disk"]
    return ibl, sod
