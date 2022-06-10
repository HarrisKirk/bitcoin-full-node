# BLIN (Bitcoin on Linode)

## Project Purpose 
To create a 1-click bitcoin-full-node on a linode instance

## Requirements and Assumptions
You must run this tool in an environment with these prerequisites

1. You are running some unix-like OS
1. Docker installed with docker daemon running
1. A linode account has been created (https://login.linode.com/signup)

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
```
make create
```

# Verify commection to the linode instance

# Create new bitcoinuser user





