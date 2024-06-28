#!/usr/bin/env bash
<< =cut

=head1 NAME

    launch_lurker.sh

=head2 SYNOPSIS

Make data collector available for listening to the probes

    [TICK=2] [BROADCAST=192.168.1.255] [RANGE=24] [PORT=6666] ./launch_writer.sh

=head2 OPTIONS

For explanation of options see L<file:../start.sh.html>

=cut
PORT=${PORT:-6666}
cd "$( dirname $0 )"
LURKER=${LURKER:-}
export LURKER
echo $$ > "../pid/$( basename $0 ).pid"
socat UDP4-RECVFROM:6666,broadcast,fork  EXEC:"./lurker.sh" &
echo $! > "../pid/lurker.sh.pid"

