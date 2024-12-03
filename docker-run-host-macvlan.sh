#!/usr/bin/env bash

# Network
IPNET=192.168.1.0/24
# IP of the container
IP=192.168.1.90
# Host gateway
GATE=192.168.1.100
# Name for the network
NETNAME=docker_dummy
# Interface name
IFNAME=ens33
docker network create -d macvlan --subnet=$IPNET --gateway=$GATE -o parent=$IFNAME $NETNAME
docker run -it --rm --network $NETNAME --ip $IP ubuntu-pimped /bin/bash
#docker run -it --rm --network $NETNAME ubuntu-pimped /bin/bash
