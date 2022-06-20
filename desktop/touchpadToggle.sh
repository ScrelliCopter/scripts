#!/bin/bash
# Touchpad toggle script for DEs that for some reason don't have that shit built in.

#name="ETPS/2 Elantech Touchpad"
name="SynPS/2 Synaptics TouchPad"
prop=`xinput list-props "$name" | grep "Device Enabled"`
[[ "$prop" == *1 ]] && xinput disable "$name" || xinput enable "$name"
