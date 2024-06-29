#!/usr/bin/env bash
<< =cut
=head1 NAME

    mkhtml

    HTML maker

=head2 SYNOPSIS

Generator of HTML output from data collected in ../data

    [DAEMON=] [SINCE=3600] mkhtml.sh

Can be used as 

    ./mkhtml.sh 

to generate the web page in ../data

=head2 OPTIONS

=over

=item DAEMON

This code will run permanently waking itself up to update the web page.

=item SINCE

The window span time you are interested in in seconds from NOW

=back

=cut
DAEMON=${DAEMON:-}
DEST=${DEST:-}
cd $( dirname $0 )
cd ../data

function main() { 
    trap "" SIGUSR1
    SINCE=${SINCE:-3600}
    OUT=$( cat <<EOF
        <!DOCTYPE html>
        <html>
        <head>
            <title>Page Title</title>
            <meta http-equiv="refresh" content="20">
        </head>

        <body>
        <table> <tr>
EOF
)

    for l in *.csv ;
    do 
        WHAT=$( echo $l | cut -d"~"  -f1 )
	this=$( echo $l | cut -d"~"  -f2 )
        WHERE=$( basename  "$this" .csv )

        SINCE=$SINCE DS=x ../bin/basic_plot.sh "$l"  &> /dev/null
        OUT="$OUT <td>$WHAT</td><td><br><br>$WHERE</td>"
        OUT="$OUT <td><pre>$( X=60 Y=20 ../bin/asci_plot.sh "$l" )</pre></td>"
        OUT="$OUT <td><img src="./$( basename "$l" .csv).g.png" /></td>"
        OUT="$OUT <td><img src="./$( basename "$l" .csv).diff.png" /></td>"
        OUT="$OUT </tr>"

    done
    if [ -z $DEST ]; then 
        echo "$OUT </tr></table>"
    else
        echo "$OUT </tr></table>" > $DEST
    fi

    trap "main" SIGUSR1

} 
if [ ! -z "$DAEMON" ]; then
	echo $$ > ../pid/$( basename $0 ).pid
    trap "main > ./index.html" SIGUSR1
    while [ 1 ]; do
        ps aux | grep [m]khtml &> /dev/null 
        if [[ $? -eq 0 ]]; then
            DAEMON= DEST=./index.html ../bin/$( basename $0 ) 
        fi

        sleep 30
    done
else 
    main
fi
