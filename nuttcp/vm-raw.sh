#!/bin/sh

LIBDIR=../common/vm
SSHOPTS="-p2222 -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"

make -C $LIBDIR

IMG=`mktemp tmpXXX.img`
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

sudo kvm -hda $IMG -hdb $LIBDIR/seed.img -m 6G -smp 4 -nographic -redir :2222::22 \
    -netdev tap,id=hostnet0,vhost=on
    >$IMG.log &

sleep 2
rm $IMG

nuttcp -S &

ssh $SSHOPTS ecylmz@localhost sudo apt-get -qq install -y nuttcp

ssh $SSHOPTS ecylmz@localhost ifconfig -a

echo "transmit client->server"
ssh $SSHOPTS ecylmz@localhost nuttcp -l8000 -t -w4m -i1 -N1 192.168.122.1
echo "receive server->client (this matters because we only measure the client)"
ssh $SSHOPTS ecylmz@localhost nuttcp -l8000 -r -w4m -i1 -N1 192.168.122.1

ssh $SSHOPTS ecylmz@localhost sudo shutdown -h now

killall nuttcp

wait
echo Experiment completed
