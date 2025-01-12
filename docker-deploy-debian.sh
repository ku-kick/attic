#!/bin/bash

cgroupfs-umount
cgroupfs-mount
containerd &
dockerd &
