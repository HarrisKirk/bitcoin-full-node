# Runtime Environment
These are the command to launch the bci command line tool directly from the image in docker hub.
```
$ alias bci="docker container run --dns=8.8.8.8 --rm --name=bci --workdir /opt/devops-bci/bci-app --user : -it -e LINODE_CLI_TOKEN -e LINODE_ROOT_PASSWORD -v /home/<username>/.ssh:/root/.ssh cjtkirk1/bitcoin-linode:latest"
$ bci
```

# Notes
* This bci software tool does not perform any financial transacations.   It also does not store or manage any keys. It simply creates a computer in the linode cloud, attaches a volume and installs the bitcoin full node software on it.   
* Docker is used to avoid needing to install python, dependent modules and any other dependencies in the future.











