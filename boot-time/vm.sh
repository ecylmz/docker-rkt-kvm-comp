#!/bin/bash

LIBDIR=../common/vm
SSHOPTS="-p2222 -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"

make -C $LIBDIR

IMG=`mktemp tmpXXX.img`
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

kvm -net nic -net user -hda $IMG -hdb $LIBDIR/seed.img -m 6G -smp 4 \
    -nographic -redir :2222::22 >$IMG.log &

# try to connect

(/usr/bin/time -f "%E" ssh $SSHOPTS ecylmz@localhost "true") |& tee -a results/vm.txt

# shut down the VM
ssh $SSHOPTS ecylmz@localhost sudo shutdown -h now

wait
echo Experiment completed

