#!/usr/bin/env bash
LURKER=${LURKER:-}
cd $( dirname $0 )
HERE="."
SINCE=${SINCE:-900}
MASTER=${MASTER:-}
TICK=${TICK:-2}
BROADCAST=${BROADCAST:-"192.168.1.255"}
RANGE=24
export TICK
$HERE/stop.sh 
echo $$ > $HERE/pid/$( basename $0).pid
[ -e pid ] || mkdir pid
[ -e log ] || mkdir log
[ -e run ] || mkdir run
[ -e data ] || mkdir data
if [ ! -z "$LURKER" ]; then
    SINCE=$SINCE DAEMON=1 $HERE/bin/mkhtml.sh &
    LURKER=$LURKER $HERE/bin/launch_lurker.sh &
fi
BROADCAST=$BROADCAST RANGE=$RANGE TICK=$TICK $HERE/bin/launch_writer.sh &
TICK=$TICK $HERE/bin/clock.sh &

