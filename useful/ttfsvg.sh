#!/bin/bash

for TTF in *.ttf
do
	DIR="${TTF%.*}"
	mkdir -p "$DIR" || break
	pushd "$DIR" || break
	fontforge -lang=ff -c 'Open($1); SelectWorthOutputting(); foreach Export("svg"); endloop;' "../$TTF" || break
	popd
done
