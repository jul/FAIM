#!/usr/bin/env bash
BROADCAST=${BROADCAST:-192.168.1.255}
RANGE=${RANGE:-24}
HERE="$( dirname $0 )"
echo $$ > "$HERE/../pid/$( basename $0 ).pid"
TICK=${TICK:-20}
if [ -z "$TICK" ]; then
    TICK=20
fi
export TICK
function speed() {
    CHANGE="speed"
}
function slow() {
    CHANGE="slow"
}
trap speed SIGUSR1
trap slow SIGUSR2

i=0
while [ 1 ]; do
    echo -n "$TICK" > $HERE/../run/living_tick.value
    sleep $TICK
    i=$(( i + 1 ))
    MASTERID=$( cat $HERE/../pid/writer.sh.pid )
    kill -s SIGUSR1 $MASTERID 
    #ps -p "$MASTERID" &> /dev/null
    if [ ! $? -eq 0 ] || [ $i -eq 100 ] ; then
        echo restarting everyone just in case
        i=0
        sleep 3
        TICK=5 LURKER=1 RANGE=$RANGE BROADCAST=$BROADCAST $HERE/../start.sh
    fi
    if [[ "$CHANGE" == "speed" ]]; then
        CHANGE=""
        echo "speed"
        TICK=` awk "BEGIN { printf \"%.4f\", $TICK / 2 }" `
        echo -n "$TICK" > $HERE/../run/living_tick.value
    fi
    if [[ "$CHANGE" == "slow" ]]; then
        CHANGE=""
        echo "slow"
        TICK=` awk "BEGIN { printf \"%.4f\", $TICK * 2 }" `
        echo -n "$TICK" > $HERE/../run/living_tick.value
    fi
done
