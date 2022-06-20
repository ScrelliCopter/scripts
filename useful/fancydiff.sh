#!/bin/sh
diff "$1" "$2" -u4 --color=always | less -R
