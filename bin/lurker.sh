#!/usr/bin/env bash
TICK=${1:-2}
SINCE=${SINCE:-900}
HERE="$( dirname $0 )"
echo ping;
echo $$ > "$HERE/../pid/$( basename $0 ).pid"
echo "$TICK" > "$HERE/../run/tick.value"
trap "echo ping" SIGUSR1
i=0;
while read -r p; do
    i=$(( i + 1 ))
    echo $p >> "$HERE/../log/journal.log" &
    TIME="$( echo $p | cut -d':' -f1 )"
    SOURCE="$( echo $p | cut -d':' -f2 )"
    DS="$( echo $p | cut -d':' -f3 )"
    VALUE="$( echo $p | cut -d':' -f4 )"
    DST="$( echo $p | cut -d':' -f5 )"
    OFB="$HERE/../data/${DS}~${SOURCE}"
    echo $TIME $VALUE >> "$OFB.csv"
done

