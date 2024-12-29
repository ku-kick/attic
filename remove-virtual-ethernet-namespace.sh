#!/bin/bash

NAMESPACE_NAME=${NAMESPACE_NAME:-dummyns}
ETHNAME1=${ETHNAME1:-eth_dummy}
ETHNAME2=${ETHNAME2:-eth_dummy1}

sudo ip link delete $ETHNAME1
sudo ip netns exec $NAMESPACE_NAME ip link delete $ETHNAME2
sudo ip netns delete $NAMESPACE_NAME
