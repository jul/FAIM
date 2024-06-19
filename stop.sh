#!/usr/bin/env bash
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
