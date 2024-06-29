#!/usr/bin/env bash
:<< =cut

=head1 NAME

stop.sh

=head2 DESCRIPTION

stops all agent launched by start

=head2 OPTIONS

None

=cut
cd $( dirname $0 )
for l in pid/*;
do 
    echo killing $l
    kill $( cat $l )
    rm $l
done
killall socat
#rm run/*
rm pid/*
#rm log/*
