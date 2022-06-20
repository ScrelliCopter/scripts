#!/bin/bash

# https://unix.stackexchange.com/a/144735

# Devices which show up in '/dev' have a 'dev' file in their '/sys'
# directory. So we search for directories matching this criteria.
for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do

	# We want the directory path, so we strip off '/dev'.
	syspath="${sysdevpath%/dev}"

	# This gives us the path in '/dev' that corresponds to this
	# '/sys' device.
	devname="$(udevadm info -q name -p $syspath)"

	# This filters out things which aren't actual devices.
	# Otherwise you'll get things like USB controllers & hubs.
	[[ "$devname" == "bus/"* ]] && continue

	# The 'udevadm info -q property --export' command lists all the
	# device properties in a format that can be parsed by the shell
	# into variables. So we simply call 'eval' on this.
	# This is also the reason why we wrap the code in the
	# parenthesis, so that we use a subshell, and the variables
	# get wiped on each loop.
	eval "$(udevadm info -q property --export -p $syspath)"

	# More filtering of things that aren't actual devices.
	[[ -z "$ID_SERIAL" ]] && continue

	# I hope you know what this line does :-)
	echo "/dev/$devname - $ID_SERIAL"
done
