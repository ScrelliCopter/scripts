#!/bin/sh
gcc -march=native -v -E - < /dev/null 2>&1 | grep cc1 | perl -pe 's/ -mno-\S+//g; s/^.* - //g;'
