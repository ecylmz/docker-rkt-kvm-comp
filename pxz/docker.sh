#!/bin/sh

# build the container
docker rm pxz:latest
docker build -t pxz .

mkdir -p results
log="results/docker.log"
now=`date`
echo "Running pxz, started at $now"

docker run --rm pxz

echo -n "Experiment completed at "; date
