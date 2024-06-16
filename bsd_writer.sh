#!/usr/bin/env bash
for (( i=0 ; i&lt;3;i++)); do
        echo $( hostname ):load_$(( 5 * ( i + 1) )):$( sysctl vm.loadavg | cut -d " " -f $(( i + 3 )) ):GAUGE
done
