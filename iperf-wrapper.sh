#!/usr/bin/env bash
if [ "$1" == "client" ]; then
    echo "Starting iperf3 client connecting to $IPERF_SRVIP"
    while [[ 1 ]]; do
        /usr/bin/iperf3 -c $IPERF_SRVIP -t 0 -b $IPERF_RATE$IPERF_OPTIONS
        sleep $IPERF_RETRY_DELAY
    done
elif [ "$1" == "server" ]; then
    echo "Starting iperf3 server"
    while [[ 1 ]]; do
        /usr/bin/iperf3 -s
        sleep $IPERF_RETRY_DELAY
    done
fi
