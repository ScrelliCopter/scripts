#!/bin/sh
set -e

onexit() {
	pactl unload-module "$MOD"
	exit
}

MOD="$(pactl load-module module-loopback latency_msec=1)"
trap onexit USR1 EXIT TERM INT
while :
do
	sleep infinity &
	wait $!
done
