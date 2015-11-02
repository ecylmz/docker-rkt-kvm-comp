#!/bin/sh

# run this on arldcn24
# you need to be part of the kvm group; try sudo usermod -a -G kvm `whoami`

LIBDIR=../common/vm
SSHOPTS="-p2222 -i ../common/id_rsa -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no -oConnectionAttempts=60"

# prepare source disk images
make -C $LIBDIR

# create ephemeral overlay qcow image
# (we probably could have used -snapshot)
IMG=`mktemp tmpXXX.img`
qemu-img create -f qcow2 -b $LIBDIR/trusty-server-cloudimg-amd64-disk1.img $IMG

# start the VM & bind port 2222 on the host to port 22 in the VM
# TODO use fancy virtio
sudo kvm -net nic -net user -hda $IMG -hdb $LIBDIR/seed.img \
    -m 4G -smp 4 -nographic -redir :2222::22 >$IMG.log &

# remove the overlay (qemu will keep it open as needed)
sleep 2
rm $IMG

rsync -a -e "ssh $SSHOPTS" . ecylmz@localhost:~/fio
rsync -a -e "ssh $SSHOPTS" /fio_dir ecylmz@localhost:~/fio_dir

# install fio
ssh $SSHOPTS ecylmz@localhost sudo apt-get -qq install -y fio

ssh $SSHOPTS ecylmz@localhost sudo mv fio_dir /fio_dir

echo Running fio - this takes 5-10 minutes
# ssh $SSHOPTS ecylmz@localhost fio - < test.fio > results/vm.log
ssh $SSHOPTS ecylmz@localhost "cd fio; fio test.fio" > results/vm.log

# shut down the VM
ssh $SSHOPTS ecylmz@localhost sudo shutdown -h now

wait
echo Experiment completed
