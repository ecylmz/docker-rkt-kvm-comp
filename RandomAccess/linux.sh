#!/bin/sh

make

now=`date`
echo "Running gups, started at $now"
echo "--------------------------------------------------------------------------------" >> results/linux.log
echo "Running gups with numaopts < $numaopts >, started at $now" >> results/linux.log
time numactl -l ./bin/gups.exe >> results/linux.log
echo "" >> results/linux.log
echo -n "Experiment completed at "; date
