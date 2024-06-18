#!/usr/bin/env bash
TICK=${TICK:-20}
./stop.sh 
rm *csv *rrd this.log
export DAEMON=1
stdbuf -i0 -o0 -e0  ./mkhtml.sh &
unset DAEMON
 stdbuf -i0 -o0 -e0 socat EXEC:"./lurker.sh $TICK" UDP4-DATAGRAM:192.168.1.255:6666,broadcast,range=192.168.1.255/24 &
stdbuf -i0 -o0 -e0 socat UDP4-RECVFROM:6666,broadcast,fork EXEC:"./writer.sh $TICK" &
