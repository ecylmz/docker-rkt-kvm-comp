#!/bin/sh

LIBDIR=../common/vm
SSHOPTS="-p2222 -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"

# prepare source disk images
make -C $LIBDIR

IMG=`mktemp tmpXXX.img`
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

numactl -l kvm -net nic -net user -hda $IMG -hdb $LIBDIR/seed.img -m 6G -smp 4 \
    -nographic -redir :2222::22 >$IMG.log &

sleep 2
rm $IMG

make

rsync -a -e "ssh $SSHOPTS" bin/ ecylmz@localhost:~

mkdir -p results
log="results/vm.log"
now=`date`
echo "Running stream, started at $now"
echo "--------------------------------------------------------------------------------" >> $log
echo "Running stream, started at $now" >> $log

ssh $SSHOPTS ecylmz@localhost "sudo apt-get -qq install -y libgomp1 && \
                              ./stream.exe " >> $log

echo "" >> $log
echo -n "Experiment completed at "; date

ssh $SSHOPTS ecylmz@localhost sudo shutdown -h now

wait
echo Experiment completed
