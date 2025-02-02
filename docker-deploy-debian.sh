#!/bin/bash

cgroupfs-umount
cgroupfs-mount
containerd &
dockerd &
D=$RANDOM
echo Mountint /var
mkdir -p /tmp/$D
mount --bind /tmp/$D /var
/bin/bash
