#!/bin/sh
arecord -D default -f S16_LE -r 48000 -c 2 --period-size=256 -B 0 --buffer-size=1024 | aplay -D default
