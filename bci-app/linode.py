from bci_common import execute_cli, execute_ssh, execute_scp, execute_sh
import os
import logging
import time

def issue_remote_vol_commands(linode_ip, vol_label, vol_filesystem_path):
    execute_ssh(linode_ip, 'root', ["mkfs.ext4", f"{vol_filesystem_path}"])
    execute_ssh(linode_ip, 'root', ["mkdir", f"/mnt/{vol_label}"])
    execute_ssh(linode_ip, 'root', ["mount", f"{vol_filesystem_path}", f"/mnt/{vol_label}"])


def wait_for_running_state(linode_id):
    cmd = ["linode-cli", "linodes", "view", str(linode_id), "--json"]
    logging.debug(" ".join(cmd))
    json_object = execute_cli(cmd)
    linode_status = json_object[0]["status"]

    while linode_status != "running":
        time.sleep(10)
        json_object = execute_cli(cmd)
        linode_status = json_object[0]["status"]
        logging.debug(f"Status = {linode_status}")


def wait_for_volume_ready():
    time.sleep(30)  # Ensure volume is ready to be mounted (status = 'active' is not sufficient)


def wait_for_volume_active(vol_id):
    cmd = ["linode-cli", "volumes", "view", str(vol_id), "--json"]
    json_object = execute_cli(cmd)
    status = json_object[0]["status"]
    logging.debug(f"Status = {status}")

    while status != "active":
        time.sleep(5)
        json_object = execute_cli(cmd)
        status = json_object[0]["status"]
        logging.debug(f"Status = {status}")
    wait_for_volume_ready()


def wait_for_detached_volume(vol_id):
    cmd = ["linode-cli", "volumes", "view", str(vol_id), "--json"]
    logging.debug(" ".join(cmd))
    json_object = execute_cli(cmd)
    linode_id = json_object[0]["linode_id"]
    logging.debug(f"linode_id = {linode_id}")

    while linode_id != None:
        time.sleep(5)
        json_object = execute_cli(cmd)
        linode_id = json_object[0]["linode_id"]
        logging.debug(f"linode_id = {linode_id}")


def remove_existing_volumes(linode_tags):
    cmd = ["linode-cli", "volumes", "list", "--tags", f"{linode_tags}", "--json"]
    logging.debug(cmd)
    json_object = execute_cli(cmd)
    volume_ids = [vol["id"] for vol in json_object]
    if len(volume_ids) == 0:
        logging.info(f"No volumes found having tags '{linode_tags}'")
    else:
        logging.info(f"Found {len(volume_ids)} volume(s) having tags '{linode_tags}': {volume_ids}")

    for volume_id in volume_ids:
        cmd = ["linode-cli", "volumes", "detach", str(volume_id), "--json"]
        json_object = execute_cli(cmd)
        wait_for_detached_volume(volume_id)
        logging.debug(f"Volume {volume_id} successfully detached.")

    for volume_id in volume_ids:
        cmd = ["linode-cli", "volumes", "delete", str(volume_id)]
        execute_cli(cmd)
        logging.info(f"Volume {volume_id} successfully deleted.")


def remove_instances(linode_tags):
    cmd = ["linode-cli", "linodes", "list", "--tags", linode_tags, "--json"]
    json_object = execute_cli(cmd)
    instances = json_object
    if len(instances) == 0:
        logging.info(f"No instances found having tags '{linode_tags}'")
    else:
        logging.info(f"Found {len(instances)} instance(s) having tags '{linode_tags}'")
        for instance in instances:
            cmd = ["linode-cli", "linodes", "delete", str(instance["id"])]
            json_object = execute_cli(cmd)
            time.sleep(2)
            logging.info(f"Instance {instance['id']} deleted.")


def cleanup(linode_tags):
    """
    Setup clean environment by removing existing volumes and instances
    """
    remove_existing_volumes(linode_tags)
    remove_instances(linode_tags)


def launch_bitcoind(linode_ip, vol_label):
    execute_ssh(linode_ip, 'root', ["chmod", "-R", "770", f"/mnt/{vol_label}"])
    execute_ssh(linode_ip, 'root', ["useradd", "-m", "--shell", "/bin/bash", "bitcoinuser"])
    execute_ssh(linode_ip, 'root', ["chown", "bitcoinuser", "-R", f"/mnt/{vol_label}"])
    execute_scp(["/opt/devops-bci/startnode.sh", f"root@{linode_ip}:/home/bitcoinuser"])
    console_out = execute_ssh(linode_ip, 'root', ['-t', 'sudo', 'su', 'bitcoinuser', '-c', "/home/bitcoinuser/startnode.sh"])
    logging.info(console_out)
    logging.info("Bitcoin node running.")


def create_instance(linode_tags):
    linode_root_pass = os.getenv("LINODE_ROOT_PASSWORD")
    ssh_key = execute_sh("cat ~/.ssh/id_rsa.pub")
    cmd = [
        "linode-cli",
        "linodes",
        "create",
        "--authorized_keys",
        ssh_key,
        "--root_pass",
        linode_root_pass,
        "--label",
        f"btcinstance-{linode_tags}",
        "--region",
        "us-east",
        "--image",
        "linode/ubuntu21.10",
        "--type",
        "g6-standard-1",
        "--tags",
        linode_tags,
        "--json",
    ]
    json_object = execute_cli(cmd)
    linode_id = json_object[0]["id"]
    linode_ip = json_object[0]["ipv4"][0]
    logging.info(f"Linode id '{linode_id}' being provisioned.")
    wait_for_running_state(linode_id)
    logging.info(f"linode id '{linode_id}' status is 'running'.")
    return linode_id, linode_ip


def create_volume(linode_id, linode_tags):
    logging.info(f"Creating volume...")
    cmd = [
        "linode-cli",
        "volumes",
        "create",
        "--label",
        f"btcvol-{linode_tags}",
        "--region",
        "us-east",
        "--linode_id",
        str(linode_id),
        "--size",
        "500",
        "--tags",
        linode_tags, 
        "--json",
    ]
    json_object = execute_cli(cmd)
    vol_id = json_object[0]["id"]
    vol_filesystem_path = json_object[0]["filesystem_path"]
    vol_label = json_object[0]["label"]
    wait_for_volume_active(vol_id)
    logging.info(f"Volume '{vol_label}' created OK with filesystem_path {vol_filesystem_path}")
    return vol_label, vol_filesystem_path

