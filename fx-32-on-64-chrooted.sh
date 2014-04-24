#!/bin/bash

# We have the location of the repo as a first argument.
cd $1

# mach stores state in a special directory.  The default directory is
# ~/.mozbuild and mach will create it for us if it doesn't exist.
# But we might as well create the directory ourselves and save it
# the trouble.
export MOZBUILD_STATE_PATH="$HOME/.mozbuild"
mkdir -m 770 -p "$MOZBUILD_STATE_PATH"

# We use mach bootstrap to install required packages rather than going
# through apt-get.
echo "Running mach bootstrap to install required packages"
./mach bootstrap
echo "OK"

echo "Building firefox!"
./mach build

echo "==="
echo "Run ./mach build again here to update your 32bits firefox build."
