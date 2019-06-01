#!/bin/sh
#set -e

# kill off any existing procs
if [ $(pidof jackd) ]
then
	pkill alsa_in
	pkill alsa_out
	pkill jackd
	jack_wait -q
fi

# restart until it works
while :
do
	# start jackd
	if [ ! $(pidof jackd) ]
	then
		/usr/bin/jackd -dalsa -r48000 -p512 -n3 -D -Chw:USB -Phw:USB &
		jack_wait -w -t 3 || continue
		
		# stop opening the fucking loopback thanks
		[ "$(jack_lsp | grep system:playback | wc -l)" -gt 4 ] && pkill jackd && continue
		[ "$(jack_lsp | grep system:capture | wc -l)" -gt 2 ] && pkill jackd && continue
	fi

	# start jack loop clients
	alsa_in -j cloop -d cloop 2>&1 1> /dev/null &
	alsa_out -j ploop -d ploop 2>&1 1> /dev/null &

	# sleep until things settle
	sleep 1

	# connect loop clients to system in/out
	jack_connect cloop:capture_1 system:playback_1
	jack_connect cloop:capture_2 system:playback_2

	jack_connect system:capture_1 ploop:playback_1
	jack_connect system:capture_2 ploop:playback_2
	
	break
done
