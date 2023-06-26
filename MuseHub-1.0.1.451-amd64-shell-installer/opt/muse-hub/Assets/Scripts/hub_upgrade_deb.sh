#!/bin/sh

if [ ! -f "$1" ]; then
    echo "Please provide a valid package location to the install script!"
    exit 1
fi

package="/muse-hub-temp.deb"

# We need to copy the input file to tmp so it's available
cp $1 $package 

if [ ! -f "$package" ]; then
    echo "Failed to copy package over to temp directory"
    exit 1
fi

# https://stackoverflow.com/a/57041270
# https://www.freedesktop.org/software/systemd/man/systemd-run.html
# Spin off a temp systemd service to run this upgrade

# What if we are not running inside sytemd, what if systemd is not installed?

# Overall this script is run as sudo, so we are good
systemd-run --unit=muse-hub.upgrade --scope --collect --slice=muse-hub.upgrade.slice -E setsid nohup sudo dpkg -i $package; rm -f $package
