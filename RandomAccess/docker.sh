#!/bin/sh

make

docker rm gups:latest
docker build -t gups .

mkdir -p results
log="results/docker.log"
now=`date`
echo "Running gups, started at $now"
echo "--------------------------------------------------------------------------------" >> $log
echo "Running gups, started at $now" >> $log
docker run --rm gups >> $log
docker rm gups
echo "" >> $log
echo -n "Experiment completed at "; date
