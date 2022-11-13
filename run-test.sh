# bci integration test script.   
#
# echo "(Keep code in a runnable state at all times)"
set -e

#\
# Basic Tests that should always work
#/
bci --help
bci create TEST --log-level=DEBUG
sleep 10
bci status TEST
bci delete TEST --log-level=DEBUG



# echo "End of $0"
