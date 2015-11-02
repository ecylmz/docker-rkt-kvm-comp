#!/bin/sh

DIR=`pwd`

# build the container (assumes the spyre git repo is in NFS)
cp /usr/bin/netserver .
echo "container building..."
docker build -t netserver $DIR

echo "netperf stopping..."
sudo service netperf stop
echo "docker running..."
CID=$(docker run -d -p 12865:12865 netserver)
CIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CID})

echo CID $CID
echo CIP $CIP
echo "netperf running..."
netperf -l 60 -H $CIP -t TCP_RR -- -r 100,200
netperf -l 60 -H $CIP -t UDP_RR -- -r 100,200

# clean up
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)

wait
echo Experiment completed
