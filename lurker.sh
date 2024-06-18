#!/usr/bin/env bash
TICK=${1:-20}
SINCE=${SINCE:-8000}
echo ping;
echo "$TICK" > tick.value
echo "$$" > mastermind.pid
trap "echo ping" SIGUSR1
i=0;
[[ "$TICK" != 0 ]] && TICK=$TICK ./clock.sh $TICK &
function create_rrd() {
   local SOURCE=$1
    local DS=$2
    local DST=$3
    rrdtool create "${SOURCE}%${DS}.rrd"   \
    --step $(( 2 * TICK )) \
   DS:x:$DST:1:0:999999999 \
   RRA:AVERAGE:0.5:1:864000 \
   RRA:AVERAGE:0.5:300:86400 \
   RRA:MIN:0.5:1:864000 \
   RRA:MAX:0.5:1:864000
}
while read p; do
    i=$(( i + 1 ))
    echo $p >> this.log &
    SOURCE="$( echo $p | cut -d':' -f1 )"
    TIME="$( echo $p | cut -d':' -f2 )"
    DS="$( echo $p | cut -d':' -f3 )"
    VALUE="$( echo $p | cut -d':' -f4 )"
    DST="$( echo $p | cut -d':' -f5 )"

    OFB="${SOURCE}%${DS}"
    sleep .2
    [ -e "$OFB.rrd" ] || create_rrd $SOURCE $DS $DST
    NOW="$( date +'%s' )"
    # rrd insert
    rrdtool update "$OFB.rrd" N:${VALUE}
    # csv insert
    echo $NOW $VALUE >> $OFB.csv
    #SINCE=$SINCE ./basic_plot.sh "$OFB.csv" 
done

