#!/usr/bin/env bash
<< =cut

=head1 NAME

    launch_writer.sh

=head2 SYNOPSIS

Make writer emit on BROADCAST/RANGE ono port PORT

    [TICK=2] [BROADCAST=192.168.1.255] [RANGE=24] [PORT=6666] ./launch_writer.sh

=head2 OPTIONS

For explanation of options see L<file:../start.sh.html>

=cut
cd "$( dirname $0 )" 
BROADCAST=${BROADCAST:-192.168.1.255} 
RANGE=${RANGE:-24}
PORT=${PORT:-6666}
TICK=${TICK:-2}
export TICK
echo $$ >> "../pid/$( basename $0 ).pid"
socat EXEC:"./writer.sh $TICK" UDP4-DATAGRAM:$BROADCAST:$PORT,broadcast,range=$BROADCAST/$RANGE &

