#!/usr/bin/env bash

PID=6302
PRELUDE="sudo nsenter -t $PID -n"

IPNET=10.0.0.0/8
# IP of the container
IP=10.0.0.100
# Host gateway
GATE=10.0.0.1
# Name for the network
# Interface name
IFNAME="h0_eth0"
NETNAME="docker-$IFNAME"

$PRELUDE ip link show
$PRELUDE ip addr show

# Create docker network
$PRELUDE docker network create -d macvlan --subnet="$IPNET" --gateway="$GATE" -o parent="$IFNAME" "$NETNAME"
# Run docker in a network
$PRELUDE docker run -it --rm --network "$NETNAME" --ip "$IP" ubuntu-pimped /bin/bash
