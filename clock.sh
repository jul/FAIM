#!/usr/bin/env bash
while [ 1 ]; do
    sleep 2
    MASTERID=$( cat mastermind.pid )
    kill -s SIGUSR1 $MASTERID
done
