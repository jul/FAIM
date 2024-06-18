#!/usr/bin/env bash

for i in plugin/*_enabled; do
   ./$i
done
