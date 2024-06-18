#!/usr/bin/env bash
TICK=${1:-20}
i=98
while [ 1 ]; do
    sleep $TICK
    i=$(( TICK + i ))
    if [[ $i > 100 ]]; then
	HTMLMAKER=$( cat htmlmaker.pid )
	kill -s SIGUSR1 $HTMLMAKER
	i=0
    fi

    MASTERID=$( cat mastermind.pid )
    kill -s SIGUSR1 $MASTERID
done
