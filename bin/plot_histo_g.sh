declare -a HISTO
SCALE=${2:-1}
BIN=${3:-1}
TOTAL=0
LINE=0
X=${X:-100}
Y=${Y:-40}
while IFS= read p; do
    LINE=$(( LINE + 1 ))
    DATA=$( echo $p | cut -d " " -f2 )
    DATA=$( printf "%.0f" $( awk "BEGIN { print $DATA * $SCALE }" ) )
    TOTAL=$(( TOTAL + DATA ))
    HISTO[$DATA]=$(( HISTO[$DATA] + 1 ))

done < $1 
for i in "${!HISTO[@]}"; do
    echo "$i ${HISTO[$i]}"
done > histo.data
echo  "total sample:$LINE"
echo -n "average value:"
awk "BEGIN { print $TOTAL/$LINE/$SCALE }"

gnuplot -e "set style histogram rowstacked gap 0 ;
set terminal png size $X,$Y ;
bin(x,width)=width*floor(x/width);
plot \"histo.data\"  smooth freq with boxes ;" > $( basename $1 .csv ).h.png
#gnuplot -e "set style histogram rowstacked gap 0 ;
#binwidth=$BIN;
#"set xtics binwidth;
#set boxwidth binwidth;
#set terminal dumb $X $Y ;
#bin(x,width)=width*floor(x/width);
#plot \"histo.data\" u (bin(\$1,binwidth)):(1.0) smooth freq with boxes ;"
