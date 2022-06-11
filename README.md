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

# Commands
To view all make commands:
```
$ make
```
# Create a linode instance 
Use Cloud Console to create an instance

# Verify connectivity to the linode instance
ssh root@<ip>

# Login to linode and perform these steps
```
$ useradd -m --shell /bin/bash bitcoinuser
$ passwd bitcoinuser
exit shell
$ login as bitcoinuser
$ ssh-keygen # press Enter for all prompts
Copy the ~/.ssh/id_rsa.pub to the github ssh keys section
$ mkdir github
$ cd github
$ git clone git@github.com:HarrisKirk/bitcoin-full-node.git
$ cd bitcoin-full-node
$ ./startnode.sh  
```









