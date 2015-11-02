#!/bin/sh

echo "netperf stopping..."
sudo service netperf stop
echo "rkt running..."
sudo rkt -insecure-skip-verify run netserver-latest.aci &

sleep 10

netperf -l 60 -H 0.0.0.0 -t TCP_RR -- -r 100,200
netperf -l 60 -H 0.0.0.0 -t UDP_RR -- -r 100,200

# cleanup
sudo kill -9 $(pidof sudo rkt)

wait
echo Experiment completed
