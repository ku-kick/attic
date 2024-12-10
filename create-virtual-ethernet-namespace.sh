#!/bin/bash

NAMESPACE_NAME=dummyns

# Create
sudo ip link add eth_dummy type veth peer name eth_dummy1

# Handle the first end
# Assign IP
sudo ip addr add 10.10.1.100/24 dev eth_dummy
# Bring up
sudo ip link set eth_dummy promisc on

# Handle the second end
sudo ip addr add 10.10.1.200/24 dev eth_dummy1
sudo ip link set eth_dummy1 promisc on
# Hide under namespace
sudo ip netns add $NAMESPACE_NAME
sudo ip link set eth_dummy1 netns $NAMESPACE_NAME

# Run both ends
sudo ip link set eth_dummy up
sudo ip netns exec $NAMESPACE_NAME ip link set eth_dummy1 up

# Verify both ends
ip addr show eth_dummy
sudo ip netns exec $NAMESPACE_NAME ip addr show eth_dummy1
