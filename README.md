# BLIN (Bitcoin on Linode)

## Project Purpose 
To create a 1-click bitcoin-full-node on a linode instance

## Requirements and Assumptions
You must run this tool in an environment with these prerequisites

1. You are running some unix-like OS
1. A linode account has been created (https://login.linode.com/signup)
1. You have create an api key and created an environment variable LINODE_CLI_TOKEN holding the api key
1. Docker installed with docker daemon running

# Docker command to avoid needing root
```
sudo usermod -aG docker $USER   # to not require sudo
```

# Preliminary Checklist
* Docker installed with daemon running?
* ps -ef | grep dockerd

# Put ssh key onto linode to avoid password
Copy the ~/.ssh/id_rsa.pub contents to the linode ssh key section via cloud console

# Create the bitcoin cloud infrastructure (instance with attached storage volume)
```
$ # CAUTION - all existing storage and nodes are deleted.
$ make 
```








