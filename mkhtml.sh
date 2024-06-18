#!/usr/bin/env bash
DAEMON=${DAEMON:-}
function main() { 
    trap "" SIGUSR1
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

    for l in *.csv ;
    do 
        where=$( echo $l | cut -d"%"  -f1 )
	this=$( echo $l | cut -d"%"  -f2 )
        what=$( basename  $this .csv )

        X=100 SINCE=$SINCE DS=x plot_rrd2.sh "$( basename $l .csv ).rrd" &> /dev/null
        SINCE=$SINCE DS=x ./basic_plot.sh "$l"  &> /dev/null
        echo "<td>$where</td><td><br><br>$what</td><td><pre>$(SINCE=$SINCE ./asci_plot.sh $l )</pre></td><td><img src="./$( basename $l .csv).png" /></td><td><img src="./$( basename $l .csv).g.png" /></td>  </tr>"

    done
    echo "</tr></table>"
    trap "main > this.html" SIGUSR1

} 
if [ ! -z "$DAEMON" ]; then
	echo $$ > htmlmaker.pid
    trap "main > this.html" SIGUSR1
    while [ 1 ]; do
        sleep 10
    done
else 
    main
fi
