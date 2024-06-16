echo "<table> <tr>"
for l in *rrd;
do 
    SINCE=1800 DS=x plot_rrd2.sh "$l" &> /dev/null;
    where=$( echo $l | cut -d"%"  -f1 )

    what=$( echo $l | cut -d"%"  -f2 )
    echo "<td>$where</td><td><br><br>$what</td><td><img height=150 src="./$( basename $l .rrd ).png" /></td></tr>"
done
echo "</tr></table>"


