#!/bin/sh

nuttcp -S &

# transmit client->server
echo "client to server (native)"
sudo perf stat -a nuttcp -t 192.168.88.103

echo "client to server (rkt NAT)"
sudo perf stat -a rkt -insecure-skip-verify run nuttcp-latest.aci > results/rkt.log

# receive server->client (this matters because we only measure the client)
echo "server to client (rkt NAT)"
sudo perf stat -a rkt -insecure-skip-verify run nuttcp1-latest.aci > results/rkt1.log

# clean up
killall nuttcp

wait
echo Experiment completed
