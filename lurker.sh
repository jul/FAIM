#!/usr/bin/env bash
echo ping;
echo "$$" > mastermind.pid
trap "echo ping" SIGUSR1
function create_rrd() {
    local SOURCE=$1
    local DS=$2
    local DST=$3
    rrdtool create "${SOURCE}%${DS}.rrd"   \
    --step 1 \
    DS:x:$DST:1:0:99 \
   RRA:AVERAGE:0.5:1:864000 \
   RRA:AVERAGE:0.5:60:129600 \
   RRA:AVERAGE:0.5:3600:13392 \
   RRA:AVERAGE:0.5:86400:3660
}
while read p; do
    SOURCE="$( echo $p | cut -d':' -f1 )"
    DS="$( echo $p | cut -d':' -f2 )"
    VALUE="$( echo $p | cut -d':' -f3 )"
    DST="$( echo $p | cut -d':' -f4 )"

    OFB="${SOURCE}%${DS}"
    [ -e "$OFB.rrd" ] || create_rrd $SOURCE $DS $DST
    NOW="$( date +'%s' )"
    # rrd insert
    rrdtool update "$OFB.rrd" $NOW:${VALUE}
    # csv insert
    echo $NOW $VALUE >> $OFB.csv
done

