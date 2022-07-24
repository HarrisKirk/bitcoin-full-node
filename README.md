# Bitcoin Cloud Infrastructure

## Project Purpose 
To create a bitcoin-full-node on a linode instance with a single command.  

## Requirements and Assumptions

1. You are running a linux distro (Ubuntu, Fedora, etc)
1. A linode account has been created (https://login.linode.com/signup)
1. Docker installed with docker daemon running
1. You have a ssh public key as ~/.ssh/id_rsa.pub

# Docker command to avoid needing root
```
sudo usermod -aG docker $USER   # to not require sudo
```

# Put ssh key onto linode to avoid password prompt
Copy the ~/.ssh/id_rsa.pub contents to the linode ssh key section via cloud console.   This step will allow the bci tool to execute commands on the remote linode instance.

# Put ssh key onto GitHub to avoid password prompt
Copy the ~/.ssh/id_rsa.pub contents to GitHub.  This step will allow you to perform a git clone.

# Test that docker has been installed correctly
```
$ make test-docker
```

# Create the bitcoin cloud infrastructure (instance with attached storage volume)
```
$ make bci

Run bci commands (use $bci --help)

Examples:
# bci create DEV    # Create a DEV bitcoin node which runs in a small volume against the 'test' bitcoin blockchain
# bci create PROD    # Create a PROD bitcoin node which runs in a large volume against the 'main' bitcoin blockchain

```
# Notes
This bci software tool does not perform any financial transacations.   It also does not store or manage any keys. It simply creates a computer in the linode cloud, attaches a volume and installs the bitcoin full node software on it.   









