#!/bin/sh

DIR=`pwd`

nuttcp -S &

# build the container (assumes the spyre git repo is in NFS)
docker build -t nuttcp - < Dockerfile
docker build -t nuttcp1 - < Dockerfile.1

# transmit client->server
echo "client to server (native)"
sudo perf stat -a nuttcp -t 192.168.88.103

echo "client to server (Docker NAT)"
sudo perf stat -a docker run nuttcp

# receive server->client (this matters because we only measure the client)
echo "server to client (Docker NAT)"
sudo perf stat -a docker run nuttcp1

# clean up
killall nuttcp

wait
echo Experiment completed
