#!/bin/bash

NAMESPACE_NAME=${NAMESPACE_NAME:-dummyns}
ETHNAME1=${ETHNAME1:-eth_dummy}
ETHNAME2=${ETHNAME2:-eth_dummy1}
IPNET1=${IPNET1:-"10.10.1.100/24"}
IPNET2=${IPNET2:-"10.10.1.200/24"}

# Create
sudo ip link add $ETHNAME1 type veth peer name $ETHNAME2

# Handle the first end
# Assign IP
sudo ip addr add $IPNET1 dev $ETHNAME1
# Bring up
sudo ip link set $ETHNAME1 promisc on

# Handle the second end
sudo ip addr add $IPNET2 dev $ETHNAME2
sudo ip link set $ETHNAME2 promisc on
# Hide under namespace
sudo ip netns add $NAMESPACE_NAME
sudo ip link set $ETHNAME2 netns $NAMESPACE_NAME

# Run both ends
sudo ip link set $ETHNAME1 up
sudo ip netns exec $NAMESPACE_NAME ip link set $ETHNAME2 up

# Verify both ends
ip addr show $ETHNAME1
sudo ip netns exec $NAMESPACE_NAME ip addr show $ETHNAME2
