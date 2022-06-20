#!/bin/sh
# https://www.blisshq.com/music-library-management-blog/2015/03/31/test-flacs-corruption/
find "$1" -type f -iname '*.flac' -print0 | xargs --null flac -wst
