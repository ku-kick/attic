#!/bin/bash

NAMESPACE_NAME=dummyns

sudo ip link delete eth_dummy
sudo ip netns exec $NAMESPACE_NAME ip link delete eth_dummy1
sudo ip netns delete $NAMESPACE_NAME
