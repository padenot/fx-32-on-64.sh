#!/bin/bash -e

# This scripts sets up and compile a 32bits Ubuntu dev environment to build
# Firefox, on a 64 bits Ubuntu machine.

CODENAME=`lsb_release -c | awk '{print $2}'`
if [ -z "$CODENAME" ]; then
  echo "Could not determine release codename from lsb_release -c!"
  exit 1
fi

DISTRIBUTOR=`lsb_release -i | awk '{print $3}'`
if [ -z "$DISTRIBUTOR"]; then
  echo "Could not determine release distributor from lsb_release -i!"
  exit 1
fi

CHROOT_NAME=${CODENAME}_i386
CHROOT_PATH=/srv/chroot/$CHROOT_NAME
# leave MC_CLONE_REMOTE_PATH empty to use a tree
# that already exists on the host, and it at MC_CLONE_LOCAL_PATH
#MC_CLONE_REMOTE_PATH=http://hg.mozilla.org/mozilla-central
MC_CLONE_LOCAL_PATH=~/mozilla-central-32


echo "Setting up the host"
[ -z `which hg` ] && sudo apt-get install -y mercurial
[ -n "$MC_CLONE_REMOTE_PATH" ] && hg clone $MC_CLONE_REMOTE_PATH $MC_CLONE_LOCAL_PATH
[ -n "$MOZCONFIG" ] && cp $MOZCONFIG $MC_CLONE_LOCAL_PATH
echo "Installing 32bit packages necessary to run a 32bits firefox on the host"
sudo apt-get install gcc-multilib g++-multilib libxrender1:i386 libasound-dev:i386 libdbus-glib-1-2:i386 libgtk2.0-0:i386 libxt-dev:i386
echo "OK"

echo "Installing debootstrap and schroot"
sudo apt-get install debootstrap schroot
echo "OK"

echo "Setting up a config file for schroot"
content="[$CHROOT_NAME]
description=Ubuntu $CODENAME 32bits
directory=$CHROOT_PATH
personality=linux32
root-users=$USER
type=directory
users=$USER"

echo "$content" | sudo tee /etc/schroot/chroot.d/${CHROOT_NAME}.conf
echo "OK"

echo "Creating the directory that will contain the chroot"
sudo mkdir -p $CHROOT_PATH
echo "OK"

if [ "$DISTRIBUTOR" = "Ubuntu" ]; then
  PACKAGES_ARCHIVE=http://archive.ubuntu.com/ubuntu
elif [ "$DISTRIBUTOR" = "Debian" ]; then
  PACKAGES_ARCHIVE=http://ftp.us.debian.org/debian
else
  echo "Unable to determine package archive for $DISTRIBUTOR"
  exit 1
fi

echo "Running debootstrap to install base system in the chroot"
sudo debootstrap --variant=buildd --arch=i386 $CODENAME $CHROOT_PATH $PACKAGES_ARCHIVE
echo "OK"

echo "Copying host source.list to chroot"
sudo cp /etc/apt/sources.list $CHROOT_PATH/etc/apt/sources.list
echo "OK"

echo "Chrooting into $CHROOT_PATH, installing sudo and build dependencies"
schroot -c $CHROOT_NAME -u root -- ./fx-32-on-64-chrooted-sudo.sh $USER
echo "OK"
echo "Chrooting into $CHROOT_PATH, building"
schroot -c $CHROOT_NAME -u $USER -- ./fx-32-on-64-chrooted.sh $MC_CLONE_LOCAL_PATH
echo "OK"
