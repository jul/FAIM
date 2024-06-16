#!/usr/bin/env bash
now=$( date +"%s" )
since=${SINCE:-400}
gnuplot -e "set xdata time;set terminal png size 821,226; set xrange [$(( now - since)):$now]; set timefmt \"%s\";set xtics rotate by 45 right; set format x \"%H:%M\"; plot \"$1\" using 1:2 with p pt \".\" " > $( basename $1 .csv ).g.png
#qiv $( basename $1 .csv ).g.png

