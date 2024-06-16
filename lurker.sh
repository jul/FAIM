#!/usr/bin/env bash
TICK=5
SINCE=${SINCE:-8000}
echo ping;
echo "$$" > mastermind.pid
trap "echo ping" SIGUSR1
function create_rrd() {
    local SOURCE=$1
    local DS=$2
    local DST=$3
    rrdtool create "${SOURCE}%${DS}.rrd"   \
    --step $TICK \
    DS:x:$DST:1:0:999999999 \
   RRA:AVERAGE:0.5:1:864000 \
   RRA:AVERAGE:0.5:300:86400 \
   RRA:MIN:0.5:1:864000 \
   RRA:MAX:0.5:1:864000 
}
i=0;
TICK=$TICK ./clock.sh &
while read p; do
    if [[ $i == 200 ]]; then
        i=0
        ./mkhtml.sh > this.html  &
    fi
    i=$(( i + 1 ))
    echo $p >> this.log &
    SOURCE="$( echo $p | cut -d':' -f1 )"
    DS="$( echo $p | cut -d':' -f2 )"
    VALUE="$( echo $p | cut -d':' -f3 )"
    DST="$( echo $p | cut -d':' -f4 )"

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

