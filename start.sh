#!/usr/bin/env bash
<< '=cut'
=head1 NAME

start.sh


=head2 DESCRIPTION

Launches the networked apparatus of measures. It is the reciprocal function
of stop.sh


=head2 SYNOPSIS

All arguments are passed by environment variables

    [TICK=2] [LURKER=] [BROADCAST=192.168.1.255] [RANGE=24] [SINCE=900] start.sh


=head2 OPTIONS

=over

=item TICK

TICK is the initial clock given to the system. It will however converge
to its computed value.

=item LURKER

When LURKER is set, the data collecting agent is launched and process 
all probes sent on the given broadcast address

=item BROADCAST

UDP BROADCAST address to use

=item RANGE

Range in the form [0-32] to specify the BROADCAST range. 

Ex: 24 will specify $BROADCAST/24

=item SINCE

Argument given to the html generator to know how much seconds since NOW must
be shown in the graph.

=back

=cut

LURKER=${LURKER:-}
cd $( dirname $0 )
HERE="."
SINCE=${SINCE:-900}
TICK=${TICK:-2}
BROADCAST=${BROADCAST:-"192.168.1.255"}
RANGE=24
export TICK
$HERE/stop.sh 
echo $$ > $HERE/pid/$( basename $0).pid
[ -e pid ] || mkdir pid
[ -e log ] || mkdir log
[ -e run ] || mkdir run
[ -e data ] || mkdir data
if [ ! -z "$LURKER" ]; then
    SINCE=$SINCE DAEMON=1 $HERE/bin/mkhtml.sh &
    LURKER=$LURKER $HERE/bin/launch_lurker.sh &
fi
BROADCAST=$BROADCAST RANGE=$RANGE TICK=$TICK $HERE/bin/launch_writer.sh &
TICK=$TICK $HERE/bin/clock.sh &

