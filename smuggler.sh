#!/bin/bash
# References:
# 1. https://akashrajpurohit.com/blog/build-your-own-docker-with-linux-namespaces-cgroups-and-chroot-handson-guide/
# 2. https://man7.org/linux/man-pages/man1/unshare.1.html?ref=akashrajpurohit.com
# 3. https://man7.org/linux/man-pages/man7/cgroups.7.html
# 4. https://blog.nginx.org/blog/what-are-namespaces-cgroups-how-do-they-work

# TODO:
# 1. pack fs as a file, use "loop" bind;
# 2. Throw in an ETH interface that can be used for networking; 
#    FOR SOME REASON, UNSHARING INTO NAMESPACE REMOVES PREVIOUSLY EXISTED INTERFACES
# 3. Test docker
# 4. Apply cgroups CPU restrictions
# 5. Integrate w/ mininet (, or containernet)

HERE=$(realpath $(dirname ${BASH_SOURCE[0]}))
NAME=bankrobber21
ROOTDIR=$HERE/$NAME
ROOTFS=$ROOTDIR/debian
MOUNTDIR=/mnt/$NAME
NETNS_FILE_PATHS=/var/run/netns

mkdir -p $ROOTDIR

echo Bootstrapping debian FS
mkdir -p $ROOTFS
#sudo debootstrap bookworm $ROOTFS http://deb.debian.org/debian/
ln -s $(realpath debian) $NAME/debian
ROOTFS=$ROOTFS/debian

echo Creating namespaces
sudo mkdir /mnt/$NAME -p
sudo mount --bind $ROOTDIR $MOUNTDIR
sudo mount --make-private $MOUNTDIR
touch $ROOTDIR/$NAME-mount
touch $ROOTDIR/$NAME-uts
touch $ROOTDIR/$NAME-pid
# Network namespace
sudo ip netns add $NAME-net
ln -s $NETNS_FILE_PATHS/$NAME-net $MOUNTDIR/$NAME-net 
# IPC namespace
touch $MOUNTDIR/$NAME-ipc

echo mounting proc
sudo mount -t proc none $ROOTFS/proc
echo mounting sysfs
sudo mount -t sysfs none $ROOTFS/sys
echo mounting dev
sudo mount -o rbind /dev $ROOTFS/dev

# Create veth-s
echo Creating virtual network within namespaces
NAMESPACE_NAME=$NAME-net create-virtual-ethernet-namespace.sh
sudo ip netns exec $NAME-net ip addr show eth_dummy1

echo Unsharing into namespaces, chrooting
#sudo unshare --uts=$MOUNTDIR/$NAME-uts \
#	--pid=$MOUNTDIR/$NAME-pid \
#	--net=$MOUNTDIR/$NAME-net \
#	--mount=$MOUNTDIR/$NAME-mount \
#	--ipc=$MOUNTDIR/$NAME-ipc \
	#--map-root-user \
	#--user \
#	/bin/bash -c "echo chrooting into the rootfs ; chroot $ROOTFS"
sudo unshare \
	--pid \
	--ipc \
	--cgroup \
	--keep-caps \
	--mount=$MOUNTDIR/$NAME-mount \
	--fork \
	/bin/bash ./docker-deploy-debian.sh

if false ; then
	echo Chrooting into the fs
	sudo chroot $ROOTFS
fi

if true ; then 
	echo Removing veth
	NAMESPACE_NAME=$NAME-net remove-virtual-ethernet-namespace.sh

	echo umounting...
	#sudo fuser -k $ROOTFS/proc
	#sudo fuser -k $ROOTFS/sys
	#sudo fuser -k $ROOTFS/dev
	#sudo fuser -k $ROOTFS
	#sudo fuser -k $MOUNTDIR/debian

	#sudo fuser -k $MOUNTDIR/$NAME-mount
	#sudo fuser -k $MOUNTDIR/$NAME-uts
	#sudo fuser -k $MOUNTDIR/$NAME-pid
	#sudo fuser -k $MOUNTDIR/$NAME-net

	sudo umount $MOUNTDIR/$NAME-mount
	sudo umount $MOUNTDIR/$NAME-uts
	sudo umount $MOUNTDIR/$NAME-pid

	sudo umount $ROOTFS/proc
	sudo umount $ROOTFS/sys
	sudo umount $ROOTFS/dev
	sudo umount $MOUNTDIR
fi
