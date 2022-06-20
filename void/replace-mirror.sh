#!/bin/sh
for i in /usr/share/xbps.d/*-repository-*.conf; do sed 's|alpha.de.repo.voidlinux.org|ftp.swin.edu.au/voidlinux|' "$i" > "/etc/xbps.d/$(basename $i)"; done
