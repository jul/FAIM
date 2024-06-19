#!/usr/bin/env bash
DS=${DS:-42}
set -e
[ -z "$1" ] && ( echo "give two rrd with a data serie named 42 to compare their series in ratio of first rrd "; exit 1; )
X=${X:-200}
Y=${Y:-43}
SINCE=${SINCE:-$(( 3600 * 24 * 7 ))}
UNTIL=${UNTIL:-0}
NOW=$( date +'%s' )
TRM=${TRM:-"dumb $X $Y"}
LC_ALL=C rrdtool graph "$( basename $1 .rrd).png" --start $(( $NOW - $SINCE ))  --end $(( $NOW - $UNTIL ))  \
    -w $(( $X * 4 )) \
    -h $(( $Y * 5 )) \
    --watermark "`date`" \
    --title "$1" \
    --font DEFAULT:7: \
    DEF:x="$1":$DS:AVERAGE  \
    VDEF:median=x,50,PERCENT \
    LINE1:x#FF0000:"median of $1"  \
    LINE2:x#000000:"$1"  \
    GPRINT:x:LAST:"Cur\: %5.2lf" \
    GPRINT:x:AVERAGE:"Avg\: %5.2lf" \
    GPRINT:x:MAX:"Max\: %5.2lf" \
    GPRINT:x:MIN:"Min\: %5.2lf" 
# qiv "$( basename $1 .rrd).png"
