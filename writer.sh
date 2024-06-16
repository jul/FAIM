#!/usr/bin/env bash
for (( i ; i<3;i++)); do
    echo $( hostname ):load_$(( 5 * ( i + 1) )):$( cat /proc/loadavg | cut -d " " -f $(( i + 1 )) ):GAUGE
done
