#!/bin/sh
# I don't think this ended up working.

dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
./configure --prefix=/usr/x86_64-w64-mingw32 --host=x86_64-w64-mingw32

