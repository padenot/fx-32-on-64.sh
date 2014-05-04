#!/bin/sh

# We just got a new sources.list, update the list of packages
apt-get update
# We don't want to build Firefox as root. Install sudo in case we need to get
# more privileges running as a normal user
# We also need to install some other packages which are not available in the
# chroot by default.
apt-get install sudo python git mercurial
