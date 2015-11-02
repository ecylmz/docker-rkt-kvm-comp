# see http://ubuntu-smoser.blogspot.co.uk/2013/02/using-ubuntu-cloud-images-without-cloud.html

all: trusty-server-cloudimg-amd64-disk1.img seed.img play.img

# download a clean VM image

trusty-server-cloudimg-amd64-disk1.img:
	wget https://cloud-images.ubuntu.com/trusty/20150928/trusty-server-cloudimg-amd64-disk1.img

# convert user data into an ISO image
seed.img: user-data
	cloud-localds seed.img user-data

# build a qcow layer for playing around
play.img: trusty-server-cloudimg-amd64-disk1.img
	qemu-img create -f qcow2 -b trusty-server-cloudimg-amd64-disk1.img play.img

play-trusty.img: trusty-server-cloudimg-amd64-disk1.img
	qemu-img create -f qcow2 -b trusty-server-cloudimg-amd64-disk1.img play.img

clean:
	rm *.img
