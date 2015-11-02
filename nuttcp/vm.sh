#!/bin/sh

LIBDIR=../common/vm
SSHOPTS="-i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"
VMIP=192.168.122.99

make -C $LIBDIR

IMG='nuttcp.qcow'
rm -f $IMG
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

sudo virsh destroy nuttcp
sudo virsh create virsh.xml

sleep 2
rm -f $IMG

nuttcp -S &

# update repository
ssh $SSHOPTS spyre@$VMIP sudo apt-get update

# install nuttcp
ssh $SSHOPTS spyre@$VMIP <<+
sudo apt-get -qq install -y nuttcp linux-tools-common linux-tools-generic linux-tools-`uname -r`
+

ssh $SSHOPTS spyre@$VMIP "route && ping -c2 192.168.122.1"

echo "TCP transmit client->server basic"
ssh $SSHOPTS spyre@$VMIP sudo perf stat -a nuttcp -t 192.168.122.1
ssh $SSHOPTS spyre@$VMIP sudo perf stat -a nuttcp -r 192.168.122.1

ssh $SSHOPTS spyre@$VMIP sudo shutdown -h now
sleep 5
sudo virsh destroy nuttcp

killall nuttcp
wait
echo Experiment completed
