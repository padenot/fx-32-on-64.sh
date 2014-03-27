#!/bin/bash

# We have the location of the repo as a first argument.
cd $1

# When mach runs for the first time, it creates a little directory, so we run
# it twice with a variable to skip the 20 seconds wait.
export MOZBUILD_STATE_PATH=~/.mozbuild
./mach build
./mach build

echo "==="
echo "Run ./mach build again here to update your 32bits firefox build."
