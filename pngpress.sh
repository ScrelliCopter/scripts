#!/bin/sh

for var in "$@"
do
	tmpfile=$(mktemp)
	zopflipng -m --lossy_transparent -y "$var" "$tmpfile"
	mv $tmpfile "$var"
done
