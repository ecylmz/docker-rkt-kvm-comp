#!/bin/sh

LIBDIR=../common/vm
SSHOPTS="-i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"
VMIP=192.168.122.99

make -C $LIBDIR

IMG=linpack.qcow
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

sudo virsh destroy linpack
sudo virsh create virsh.xml

sleep 2
rm -f $IMG

ssh $SSHOPTS ecylmz@$VMIP sudo apt-get install -y hwloc
ssh $SSHOPTS ecylmz@$VMIP lstopo --of console > results/vm.tuned.topo

ssh $SSHOPTS ecylmz@$VMIP sudo apt-get install -qq -y libgomp1 libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 numactl

rsync -a -e "ssh $SSHOPTS" bin/ ecylmz@$VMIP:~

mkdir -p results
log="results/vm.log"
now=`date`
echo "Running linpack, started at $now"
echo "--------------------------------------------------------------------------------" >> $log
echo "Running linpack, started at $now" >> $log

ssh $SSHOPTS ecylmz@$VMIP ./runme_xeon32 >> $log

echo "" >> $log
echo -n "Experiment completed at "; date

ssh $SSHOPTS ecylmz@$VMIP sudo shutdown -h now

wait
echo Experiment completed
