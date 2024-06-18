#!/usr/bin/env bash
now=$( date +"%s" )
since=${SINCE:-400}
gnuplot -e "set xdata time;set terminal dumb 60 20; set xrange [$(( now - since)):$now]; set timefmt \"%s\";set xtics rotate by 45 right; set format x \"%H:%M\"; plot \"$1\" using 1:2 with l lines \"-\" " 
#qiv $( basename $1 .csv ).g.png

