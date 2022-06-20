#/bin/sh
OUT="$1"
cat $(find . -name "*.VOB" -a ! -name "VTS_01_0.VOB" -a ! -name "VIDEO_TS.VOB") | ffmpeg -i pipe:0 -acodec copy -vcodec copy -y "$OUT"
