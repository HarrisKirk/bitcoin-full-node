# BLIN (Bitcoin on Linode)

## Project Purpose 
To create a 1-click bitcoin-full-node on a linode instance

## Requirements and Assumptions
You must run this tool in an environment with these prerequisites

1. A linode account has been created (https://login.linode.com/signup)
1. You are running some unix-like OS
1. Docker installed with docker daemon running

# Docker command to avoid needing root
```
sudo usermod -aG docker $USER   # to not require sudo
```

# Preliminary Checklist
* Docker installed with daemon running?
* ps -ef | grep dockerd


# Create a linode instance 
Ensure all existing linode instances and volumes are removed via the Cloud Manager UI
```
$ make bci
```

# Login to linode and perform these steps to create bitcoinuser
```
$ ssh root@<ip> # obtain the IP on the Cloud Console
$ chmod -R 777 /mnt/btc_node_data
$ useradd -m --shell /bin/bash bitcoinuser
$ passwd bitcoinuser
$ su --login bitcoinuser
$ ssh-keygen # press Enter for all prompts
$ cat ~/.ssh/id_rsa.pub
Copy the ~/.ssh/id_rsa.pub to the github ssh keys section
```

# Download and start the bitcoin full node
```
$ mkdir github
$ cd github
$ git clone git@github.com:HarrisKirk/bitcoin-full-node.git
$ cd bitcoin-full-node
$ ./startnode.sh  
$ cd bitcoin_core/bitcoin-23.0/bin
$ ./bitcoin-cli getblockchaininfo # wait for initialblockdownload: false
```







