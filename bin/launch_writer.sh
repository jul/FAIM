#!/usr/bin/env bash
cd "$( dirname $0 )" 
LURKER=1
export LURKER
BROADCAST=${BROADCAST:-192.168.1.255} 
RANGE=${RANGE:-24}
echo $$ >> "../pid/$( basename $0 ).pid"
socat EXEC:"./writer.sh $TICK" UDP4-DATAGRAM:$BROADCAST:6666,broadcast,range=$BROADCAST/$RANGE &

