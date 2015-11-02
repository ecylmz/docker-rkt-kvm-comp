#!/bin/sh

LIBDIR=../common/vm
SSHOPTS="-p2222 -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"

# prepare source disk images
make -C $LIBDIR

# create ephemeral overlay qcow image
# (we probably could have used -snapshot)
IMG=`mktemp tmpXXX.img`
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

# start the VM & bind port 2222 on the host to port 22 in the VM
numactl $numaopts kvm -net nic -net user -hda $IMG -hdb $LIBDIR/seed.img -m 6G -smp 4 \
    -nographic -redir :2222::22 >$IMG.log &

# remove the overlay (qemu will keep it open as needed)
sleep 2
rm $IMG

# build gups
make

# copy code in (we could use Ansible for this kind of thing, but...)
rsync -a -e "ssh $SSHOPTS" bin/ ecylmz@localhost:~

# annotate the log
mkdir -p results
log="results/vm.log"
now=`date`
echo "Running gups, started at $now"
echo "--------------------------------------------------------------------------------" >> $log
echo "Running gups, started at $now" >> $log

# run gups and copy out results
ssh $SSHOPTS ecylmz@localhost "sudo apt-get -qq install -y libgomp1 && \
                              ./gups.exe" >> $log

# annotate the log
echo "" >> $log
echo -n "Experiment completed at "; date

# shut down the VM
ssh $SSHOPTS ecylmz@localhost sudo shutdown -h now

wait
echo Experiment completed
