#!/usr/bin/env bash
cd "$( dirname $0 )"
LURKER=${LURKER:-}
export LURKER
echo $$ > "../pid/$( basename $0 ).pid"
socat UDP4-RECVFROM:6666,broadcast,fork,ttl=3  EXEC:"./lurker.sh $TICK" &
echo $! > "../pid/lurker.sh.pid"

