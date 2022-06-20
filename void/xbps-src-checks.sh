#!/bin/sh
set -e

PKG="$1"
JOBS=-j$(nproc --all)
BRANCH="$(git branch --show-current)"

xlint "$PKG"

[ ! "$BRANCH" = "master" ] && rm -rf "hostdir/binpkgs/$BRANCH/"

./xbps-src clean
./xbps-src $JOBS pkg "$PKG"

for i in aarch64 armv7l x86_64-musl armv6l-musl aarch64-musl i686; do
	./xbps-src clean "$PKG"
	./xbps-src $JOBS pkg -a "$i" "$PKG"
done
