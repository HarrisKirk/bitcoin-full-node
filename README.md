# Bitcoin Cloud Infrastructure


## Project Purpose 
To build a command line tool that will be a foundation for implementing bitcoin node operations on linode.   The current feature is creation of a bitcoin-full-node with options to specify which blockchain and volume size.  

## Requirements

1. You are running a linux distro (Ubuntu, Fedora, etc)
1. Docker is installed with docker daemon running
    * This command will install on Ubuntu: `sudo apt install docker.io`
1. A linode account has been created (https://login.linode.com/signup)
1. You have a ssh public key as **~/.ssh/id_rsa.pub**
    * If you have no existing public key, you can create one with `ssh-keygen` and press enter for all questions.

### Create environment variables (put into ~/.bashrc)
On the linode Cloud Manager, select "Profile and Account" in the top right corner.    Select "API Tokens" then "Create a Personal Access Token" one with the default privileges (only linode instance and volume creation are needed).   Copy the API token and place it in the environment variable LINODE_API_TOKEN as below:
```
export LINODE_CLI_TOKEN="2a2f4563d1......33ca8a32e23"   # Create with linode Cloud Manager 
export LINODE_ROOT_PASSWORD="mypassword" 
```


### Put ssh key onto linode to avoid password prompt
Copy the ~/.ssh/id_rsa.pub contents to the linode ssh key section via cloud console.   This step will allow the bci tool to execute commands on the remote linode instance without requiring a password.

## Development Environment
These are the steps to create a bci development environment
1. Clone this git repo into a directory of your choice.
1. Install make: `sudo apt install make`

### Test that make has been installed correctly
```
$ make
:
:
:
```

### Test that docker has been installed correctly
```
$ make test-docker
```
* The following message should appear:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Running the bci tool
```
$ make bci # Might take a few minutes the first time.  It will be very fast subsequently.
```
Run bci commands (use $bci --help)

Examples:
```
# bci create DEV    # Create a DEV bitcoin node which runs in a small volume against the 'test' bitcoin blockchain
# bci create PROD    # Create a PROD bitcoin node which runs in a large volume against the 'main' bitcoin blockchain
```
Note: command line completion is enabled so that you can press the [TAB] key to get a list of valid commands and parameters after the 'bci'

* Example 1: ```$bci [tab]``` 
* Example 2: ```$bci c[tab]```

## Release Process
Every pushed commit will run the github workflow (.github/workflows/build.yml) and run the integration tests.  If these integration tests pass the image will be tagged and pushed to Dockerhub.

To apply a tag (eg 1.0) use these steps _after_ a successful build on github:
```
git tag -m "Annotated comment" x.y master
git push origin x.y
```
The build will run on github (https://github.com/HarrisKirk/bitcoin-full-node/actions) and will use the git tag to label the image when pushed to Dockerhub.

## Runtime Environment
These are the command to launch the bci command line tool directly from the image in docker hub.
```
$ alias bci="docker container run --rm --name=bci --workdir /opt/devops-bci/bci-app --user : -it -e LINODE_CLI_TOKEN -e LINODE_ROOT_PASSWORD -v /home/$(whoami)/.ssh:/root/.ssh cjtkirk1/bitcoin-linode:latest"
$ bci
```


# Notes
* This bci software tool does not perform any financial transacations.   It also does not store or manage any keys. It simply creates a computer in the linode cloud, attaches a volume and installs the bitcoin full node software on it.   
* Docker is used to avoid needing to install python, dependent modules and any other dependencies in the future.











