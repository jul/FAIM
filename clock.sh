#!/usr/bin/env bash
TICK=${TICK:-5}

while [ 1 ]; do
    sleep $TICK
    MASTERID=$( cat mastermind.pid )
    kill -s SIGUSR1 $MASTERID
done
