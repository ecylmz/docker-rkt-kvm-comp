#!/bin/sh

# make

now=`date`
echo "Running linpack, started at $now"
echo "--------------------------------------------------------------------------------" >> results/linux.log
echo "Running linpack with numaopts < $numaopts >, started at $now" >> results/linux.log
cd bin
time numactl --physcpubind=0 --interleave=0 ./runme_xeon32 >> ../results/linux.log


echo "" >> ../results/linux.log
echo -n "Experiment completed at "; date
