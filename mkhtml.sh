#!/usr/bin/env bash
SINCE=${SINCE:-900}
cat <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Page Title</title>
    <meta http-equiv="refresh" content="10">
</head>

<body>
<table> <tr>
EOF

for l in *rrd;
do 
    SINCE=1800 DS=x plot_rrd2.sh "$l" &> /dev/null;
    where=$( echo $l | cut -d"%"  -f1 )

    what=$( basename $( echo $l | cut -d"%"  -f2 ) .rrd )
    OFB=$( basename $l .rrd )
    echo "<td>$where</td><td><br><br>$what</td><td><img height=200 src="./$( basename $l .rrd ).png" /><img height=200 src="./$( basename $l .rrd ).g.png"/></td></tr>"
    PLOT= SINCE=$SINCE DS=x plot_rrd2.sh "$OFB.rrd" &> /dev/null 
    SINCE=$SINCE ./basic_plot.sh "$OFB.csv" &> /dev/null
done
echo "</tr></table>"



