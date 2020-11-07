#!/bin/bash

readarray -t replaces
i=0

while read -u 10 line; do
    if [[ $line == *'/* FRAMES */'* ]]; then
        echo "$line" | sed -e "s@/\* FRAMES \*/@\[${replaces[$i]}\]@"
        i=$(( $i + 1 ))
    else
        echo "$line"
    fi
done 10< base.dot
