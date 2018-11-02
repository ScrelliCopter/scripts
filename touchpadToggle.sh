#!/bin/bash
# Touchpad toggle script for DEs that for some reason don't have that shit built in.

prop=`xinput list-props "ETPS/2 Elantech Touchpad" | grep "Device Enabled"`
[[ "$prop" == *1 ]] && xinput disable "ETPS/2 Elantech Touchpad" || xinput enable "ETPS/2 Elantech Touchpad"
