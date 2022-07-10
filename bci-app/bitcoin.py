from common import execute_ssh, execute_scp
import logging

def launch_bitcoind(linode_ip, chain, vol_label):
    logging.info(f"Launching bitcoind with chain={chain} and datadir=/mnt/{vol_label}")
    execute_ssh(linode_ip, "root", ["chmod", "-R", "770", f"/mnt/{vol_label}"])
    execute_ssh(linode_ip, "root", ["useradd", "-m", "--shell", "/bin/bash", "bitcoinuser"])
    execute_ssh(linode_ip, "root", ["chown", "bitcoinuser:bitcoinuser", "-R", f"/mnt/{vol_label}"])
    execute_scp(["/opt/devops-bci/startnode.sh", f"root@{linode_ip}:/home/bitcoinuser"])
    execute_ssh(linode_ip, "root", ["chown", "bitcoinuser:bitcoinuser", "-R", f"/home/bitcoinuser/startnode.sh"])
    console_out = execute_ssh(
        linode_ip, "root", ["-t", "sudo", "-u", "bitcoinuser", f"/home/bitcoinuser/startnode.sh", chain, f"/mnt/{vol_label}"]
    )
    logging.info(console_out)
    logging.info("Bitcoin node running.")


