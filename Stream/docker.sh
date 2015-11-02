#!/bin/sh

# build the container
docker rm stream:latest
docker build -t stream .

mkdir -p results
log="results/docker.log"
now=`date`
echo "Running stream, started at $now"
echo "--------------------------------------------------------------------------------" >> $log
echo "Running stream, started at $now" >> $log
docker run --rm stream >> $log

echo "" >> $log
echo -n "Experiment completed at "; date
