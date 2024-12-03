#!/bin/bash

# Create
sudo ip link add eth_dummy type veth peer name eth_dummy1

# Handle the first end
# Assign IP
sudo ip addr add 192.168.1.100/24 dev eth_dummy
# Bring up
sudo ip link set eth_dummy up
#sudo ip link set eth_dummy promisc on
# Verify
ip addr show eth_dummy

# Handle the second end
sudo ip addr add 192.168.1.200/24 dev eth_dummy1
#sudo ip link set eth_dummy1 promisc on
sudo ip link set eth_dummy1 up
ip addr show eth_dummy1
