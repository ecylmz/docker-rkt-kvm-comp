#!/bin/sh

DIR=`pwd`

docker build -t fio $DIR

echo Running fio - this takes 5-10 minutes
docker run --rm fio > results/docker.log

wait
echo Experiment completed
