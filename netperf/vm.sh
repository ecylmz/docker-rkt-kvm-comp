#!/bin/sh

LIBDIR=../common/vm
SSHOPTS="-i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"
VMIP=192.168.122.99

make -C $LIBDIR

IMG='netperf.qcow'
rm -f $IMG
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

sudo virsh destroy netperf
sudo virsh create virsh.xml

sleep 2
rm -f $IMG

ssh $SSHOPTS ecylmz@$VMIP echo hello VM
date

ssh $SSHOPTS ecylmz@$VMIP "route && ping -c2 192.168.122.1"

# install netperf  ... the hard way
scp $SSHOPTS `which netserver` ecylmz@$VMIP:~
ssh $SSHOPTS ecylmz@$VMIP sudo ./netserver -v -p 12865 &
sleep 2

echo "TCP_RR"
netperf -l 60 -H $VMIP -t TCP_RR -- -r 100,200
netperf -l 60 -H $VMIP -t TCP_RR -- -r 100,200
netperf -l 60 -H $VMIP -t TCP_RR -- -r 100,200
netperf -l 60 -H $VMIP -t TCP_RR -- -r 100,200
netperf -l 60 -H $VMIP -t TCP_RR -- -r 100,200

echo "UDP_RR"
netperf -l 60 -H $VMIP -t UDP_RR -- -r 100,200
netperf -l 60 -H $VMIP -t UDP_RR -- -r 100,200
netperf -l 60 -H $VMIP -t UDP_RR -- -r 100,200
netperf -l 60 -H $VMIP -t UDP_RR -- -r 100,200
netperf -l 60 -H $VMIP -t UDP_RR -- -r 100,200

# TODO copy out results

# shut down the VM
ssh $SSHOPTS ecylmz@$VMIP sudo shutdown -h now
sleep 5
sudo virsh destroy netperf

wait
echo Experiment completed
