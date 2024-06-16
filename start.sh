#!/usr/bin/env bash
killall socat
for p in $( ps aux | grep "[c]lock.sh" | tr -s " " | cut -f2 -d" " );
do
    kill $p
done

socat EXEC:"./lurker.sh" UDP4-DATAGRAM:192.168.1.255:6666,broadcast,range=192.168.1.255/24 &
socat UDP4-RECVFROM:6666,broadcast,fork EXEC:"./writer.sh" &
