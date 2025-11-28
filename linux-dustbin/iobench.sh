#!/bin/bash
DEVICE="$1"

do_ping() {
    ioping -RD "$@" "$DEVICE" | grep 'requests completed' | cut -d ',' -f 3,4
}

echo -n "4K rand read:        "
do_ping -s 4K

echo -n "128K rand read:      "
do_ping -s 128K

echo -n "1M rand read:        "
do_ping -s 1M
