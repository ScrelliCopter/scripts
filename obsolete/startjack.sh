#!/bin/sh
#set -e

# kill off any existing procs
if [ $(pidof jackd) ]
then
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
	fi
	break
done
