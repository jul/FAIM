#!/usr/bin/env bash
TICK=${1:-2}
SINCE=${SINCE:-900}
HERE="$( dirname $0 )"
echo ping;
echo $$ > "$HERE/../pid/$( basename $0 ).pid"
echo "$TICK" > "$HERE/../run/tick.value"
trap "echo ping" SIGUSR1
i=0;
function create_rrd() {
   local SOURCE=$1
    local DS=$2
    local DST=$3
    re='^[0-9]+$'
    if [[ ! $TICK =~ $re ]]; then
        TICK=1
    fi
    rrdtool create "$HERE/../data/${DS}~${SOURCE}.rrd"   \
    --step $(( 10 )) \
   DS:x:$DST:1:0:999999999 \
   RRA:AVERAGE:0.9:1:864000 \
   RRA:AVERAGE:0.5:1d:4000 \
   RRA:MIN:0.5:1:864000 \
   RRA:MAX:0.5:1:864000
}
while read -r p; do
    i=$(( i + 1 ))
    echo $p >> "$HERE/../log/journal.log" &
    TIME="$( echo $p | cut -d':' -f1 )"
    SOURCE="$( echo $p | cut -d':' -f2 )"
    DS="$( echo $p | cut -d':' -f3 )"
    VALUE="$( echo $p | cut -d':' -f4 )"
    DST="$( echo $p | cut -d':' -f5 )"

    OFB="$HERE/../data/${DS}~${SOURCE}"
     [ -e "$OFB.rrd" ] || create_rrd $SOURCE $DS $DST
     rrdtool update "$OFB.rrd" $TIME:${VALUE}
    echo $TIME $VALUE >> "$OFB.csv"
done

