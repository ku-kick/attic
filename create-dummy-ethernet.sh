#!/bin/bash

# Load dummy module
sudo modprobe dummy
# Create
sudo ip link add eth_dummy type dummy
# Assign IP
sudo ip addr add 192.168.1.100/24 dev eth_dummy
# Bring up
sudo ip link set eth_dummy up
# Verify
ip addr show eth_dummy

#sudo ip addr add 192.168.1.40/24 dev eth_dummy

# Set prostitution mode
ip link set eth_dummy promisc on
