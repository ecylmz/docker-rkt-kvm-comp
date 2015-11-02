#!/bin/sh

make

now=`date`
echo "Running stream, started at $now"
echo "--------------------------------------------------------------------------------" >> results/linux.log
echo "Running stream with numaopts < $numaopts >, started at $now" >> results/linux.log
time numactl -l ./bin/stream.exe >> results/linux.log
echo "" >> results/linux.log
echo -n "Experiment completed at "; date
