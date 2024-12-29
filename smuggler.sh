#!/bin/bash
# References:
# 1. https://akashrajpurohit.com/blog/build-your-own-docker-with-linux-namespaces-cgroups-and-chroot-handson-guide/
# 2. https://man7.org/linux/man-pages/man1/unshare.1.html?ref=akashrajpurohit.com
# 3. https://man7.org/linux/man-pages/man7/cgroups.7.html
# 4. https://blog.nginx.org/blog/what-are-namespaces-cgroups-how-do-they-work

# TODO:
# 1. pack fs as a file, use "loop" bind;
# 2. Throw in an ETH interface that can be used for networking;
# 3. Test docker 
# 4. Apply cgroups CPU restrictions 
# 5. Integrate w/ mininet (, or containernet)

HERE=$(realpath $(dirname ${BASH_SOURCE[0]}))
NAME=bankrobber6
ROOTDIR=$HERE/$NAME
ROOTFS=$ROOTDIR/debian
MOUNTDIR=/mnt/$NAME

mkdir -p $ROOTDIR

mkdir -p $ROOTFS
sudo debootstrap bookworm $ROOTFS http://deb.debian.org/debian/

sudo mkdir /mnt/$NAME -p
sudo mount --bind $ROOTDIR $MOUNTDIR
sudo mount --make-private $MOUNTDIR
touch $MOUNTDIR/$NAME-mount
touch $MOUNTDIR/$NAME-uts
touch $MOUNTDIR/$NAME-pid
touch $MOUNTDIR/$NAME-net
touch $MOUNTDIR/$NAME-ipc

sudo unshare --uts=$MOUNTDIR/$NAME-uts \
	--pid=$MOUNTDIR/$NAME-pid \
	--net=$MOUNTDIR/$NAME-net \
	--mount=$MOUNTDIR/$NAME-mount \
	--ipc=$MOUNTDIR/$NAME-ipc \
	--fork

mount -t proc none $ROOTFS/proc
mount -t sysfs none $ROOTFS/sys
mount -o bind /dev $ROOTFS/dev
chroot $ROOTFS
