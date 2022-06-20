#!/bin/sh
for i in *.m4a; do ffmpeg -i "$i" -compression_level 12 -map_metadata 0 -map_metadata 0:s:0 -id3v2_version 3 "${i%%.m4a}.flac"; done
