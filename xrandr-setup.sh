#!/bin/sh
xrandr --output DisplayPort-0 --mode 2560x1440 --pos 0x0 --rotate normal --output DVI-D-0 \
--primary --mode 1920x1080 --pos 2560x0 --rotate normal --rate 144 --output DVI-D-1 --off --output \
HDMI-A-0 --off
