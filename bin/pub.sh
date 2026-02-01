#!/usr/bin/env bash
mosquitto_pub --cert cfg/4711.crt --key cfg/4711.key --cafile cfg/RootCA.crt -h badass.home -t BUS -u 4711 -P 4711 -m "$1"
