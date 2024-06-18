#!/usr/bin/env bash
killall socat

for p in $( ps aux | grep "[c]lock.sh" | tr -s " " | cut -f2 -d" " );
do
    kill $p
done
for p in $( ps aux | grep "[m]khtml.sh" | tr -s " " | cut -f2 -d" " );
do
    kill $p
done
