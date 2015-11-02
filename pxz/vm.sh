#!/bin/sh

LIBDIR=../common/vm
SSHOPTS="-p2222 -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"

make -C $LIBDIR

IMG=`mktemp tmpXXX.img`
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

kvm -net nic -net user -hda $IMG -hdb $LIBDIR/seed.img -m 6G -smp 4 \
    -nographic -redir :2222::22 >$IMG.log &

sleep 2
rm $IMG

# install packages
ssh $SSHOPTS ecylmz@$VMIP "sudo apt-get update; sudo apt-get install -y build-essential liblzma-dev time"

rsync -a -e "ssh $SSHOPTS" pxz/ ecylmz@localhost:~

now=`date`
echo "Running pxz, started at $now"
echo "--------------------------------------------------------------------------------" >> $log
echo "Running pxz, started at $now" >> $log

ssh $SSHOPTS ecylmz@$VMIP "cd ~/pxz; /usr/bin/time -f "%E real,%U user,%S sys" ./pxz -kvf -2 sample.txt"

# shut down the VM
ssh $SSHOPTS ecylmz@localhost sudo shutdown -h now

wait
echo Experiment completed

