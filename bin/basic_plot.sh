#!/usr/bin/env bash
now=$( date +"%s" )
since=${SINCE:-400}
X=${X:-421}
Y=${Y:-226}
#qiv $( basename $1 .csv ).g.png
gnuplot -e "
set terminal png size $X,$Y; 
set xrange [$(( now - since)):$now]; 
set xdata time;
set timefmt \"%s\";
set xtics rotate by 45 right; 
set format x \"%H:%M\"; 
plot \"$1\" using 1:2 with l  " > $( basename $1 .csv ).g.png
gnuplot -e "set terminal png size $X,$Y;
delta_v(x) = ( vD = x - old_v, old_v = x, vD);
old_v = NaN;
set xdata time;
set timefmt \"%s\";
set title \"derive\";
set xtics rotate by 45 right; 
set format x \"%H:%M\"; 
set xrange [$(( now - since)):$now];
plot \"$1\" using 1:(delta_v(\$2)) with l" > $( basename $1 .csv ).diff.png


