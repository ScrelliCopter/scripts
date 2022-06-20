#!/bin/sh
set -e

IN="$1"
OUT="$2"

inkscape -w 960 -h 960 "$IN" -o "$OUT"
convert poop.png -resize 480x480 -gravity center -background transparent -extent 512x512 "$OUT"
zopflipng -y -q --lossy_transparent "$OUT" "$OUT"
