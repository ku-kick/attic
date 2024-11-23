#!/usr/bin/env bash

IPNET=192.168.1.0/24
IP=192.168.1.90
GATE=192.168.1.100
NETNAME=docker_dummy
docker network create -d macvlan --subnet=$IPNET --gateway=$GATE -o parent=eth_dummy $NETNAME
#docker run -it --rm --network $NETNAME --ip $IP ubuntu-pimped /bin/bash
docker run -it --rm --network $NETNAME ubuntu-pimped /bin/bash
