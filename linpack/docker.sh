#!/bin/sh

DIR=`pwd`

docker build -t linpack $DIR

mkdir -p results
log="results/docker.log"
now=`date`
echo "Running linpack, started at $now"
echo "--------------------------------------------------------------------------------" >> $log
echo "Running linpack, started at $now" >> $log
docker run --rm linpack >> $log

echo "" >> $log
echo -n "Experiment completed at "; date
