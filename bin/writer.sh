#!/usr/bin/env bash
TICK=${1:-${TICK:-1}}
LURKER=${LURKER:-}
#sleep $(( RANDOM % TICK ))
RES=""
HERE="$( dirname $0 )"
NOW_HRES=$( date +'%s.%N' )
NOW=$( date +'%s' )
HOST=$( hostname )
PRUDENCE=25
if [ ! -z "$TICK" ]; then 
    echo $$ > "$HERE/../pid/$( basename $0 ).pid"
fi

for i in $HERE/plugin/*_enabled; do
   RES+=$( ./$i )
   RES+="\n"
done
PROCESSING_TIME_HRES=$( awk "BEGIN { print $( date +'%s.%N' ) - $NOW_HRES  }") 
function log() {
    echo "$@" >> "$HERE/../log/alarm.txt"
}
function answer() {
RES+="$NOW:$HOST:writer.proctime:$PROCESSING_TIME_HRES:GAUGE\n"

if [ ! -z "$TICK" ]; then 
    CLOCK_PID=$( cat $HERE/../pid/clock.sh.pid )
    LIVING_TICK=$( cat $HERE/../run/living_tick.value )
    log "condi  ( $PRUDENCE * $PROCESSING_TIME_HRES ) > $LIVING_TICK $( echo " ( $PRUDENCE * $PROCESSING_TIME_HRES ) > $LIVING_TICK" | bc )"
    if [ $( echo " ( $PRUDENCE * $PROCESSING_TIME_HRES ) > $LIVING_TICK" | bc ) -eq 1 ]; then
        ALARM="OVERRUN $PROCESSING_TIME_HRES > $LIVING_TICK slowing clock"
        kill -s SIGUSR2 $CLOCK_PID;
        log "$ALARM $LIVING_TICK"
    fi
    log "cond 2 $( echo " ( $PRUDENCE * $PROCESSING_TIME_HRES ) > $LIVING_TICK" | bc )"
    if [ $( echo "$PROCESSING_TIME_HRES < ( $PRUDENCE * $LIVING_TICK )" | bc ) -eq 1 ]; then
        ALARM="UNDERRUN $PROCESSING_TIME_HRES < $LIVING_TICK speeding clock"
        kill -s SIGUSR1 $CLOCK_PID;
        log "$ALARM $LIVING_TICK" 
        echo "$NOW:$HOST:clock.live_tick:$LIVING_TICK:GAUGE"
    fi
    OLD_TICK=$( cat "$HERE/../run/last_tick.value" || echo 0 )
    RES+="$NOW:$HOST:tick:${OLD_TICK}:DERIVE\,"
    echo -n $(( $OLD_TICK +1 )) > "$HERE/../run/last_tick.value"
fi
RES="${RES::-2}"
echo -e "$RES"
}
trap answer SIGUSR1
if [ "$TICK"  ]; then
    while [ 1 ]; do
        sleep 1;
    done
else
    answer
fi
