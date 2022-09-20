# Runtime Environment Requirements

1. You are running a linux distro (Ubuntu, Fedora, etc)
1. Docker is installed with docker daemon running
    * This command will install on Ubuntu: `sudo apt install docker.io`
1. A linode account has been created (https://login.linode.com/signup)
1. You have a ssh public key as **~/.ssh/id_rsa.pub**
    * If you have no existing public key, you can create one with `ssh-keygen` and press enter for all questions.

# Create environment variables (put into ~/.bashrc)
On the linode Cloud Manager, select "Profile and Account" in the top right corner.    Select "API Tokens" then "Create a Personal Access Token" one with the default privileges (only linode instance and volume creation are needed).   Copy the API token and place it in the environment variable LINODE_API_TOKEN as below:
```
export LINODE_CLI_TOKEN="2a2f4563d1......33ca8a32e23"   # Create with linode Cloud Manager 
export LINODE_ROOT_PASSWORD="mypassword" 
```

These are the command to launch the bci command line tool directly from the image in docker hub.
```
$ alias bci="docker container run --dns=8.8.8.8 --rm --name=bci --workdir /opt/devops-bci/bci-app --user : -it -e LINODE_CLI_TOKEN -e LINODE_ROOT_PASSWORD -v /home/<username>/.ssh:/root/.ssh cjtkirk1/bitcoin-linode:latest"
$ bci
```

# Running the bci tool
```
bci --help
```

# Notes
* This bci software tool does not perform any financial transacations.   It also does not store or manage any keys. It simply creates a computer in the linode cloud, attaches a volume and installs the bitcoin full node software on it.   
* Docker is used to avoid needing to install python, dependent modules and any other dependencies in the future.











