#!/bin/sh

pkill jackd
pkill alsa_in
pkill alsa_out

sleep 3

set -e

# start jackd
/usr/bin/jackd -dalsa -r48000 -p512 -n3 -D -Chw:USB -Phw:USB &

# start jack loop clients
alsa_in -j cloop -d cloop 2>&1 1> /dev/null &
alsa_out -j ploop -d ploop 2>&1 1> /dev/null &

# sleep until things settle
sleep 2

# connect loop clients to system in/out
jack_connect cloop:capture_1 system:playback_1
jack_connect cloop:capture_2 system:playback_2

jack_connect system:capture_1 ploop:playback_1
jack_connect system:capture_2 ploop:playback_2
