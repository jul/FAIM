#!/usr/bin/env bash
<< =cut

=head1 NAME

    lurker.sh

=head2 SYNOPSIS

Collector of data

    ./lurker.sh

Can be used as 

    while [ 1 ]; do writer.sh | lurker.sh; sleep 30; done

To collect data emitted locally about the machine.

Results are written in ../data


=cut
HERE="$( dirname $0 )"
echo $$ > "$HERE/../pid/$( basename $0 ).pid"
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

