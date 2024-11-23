#!/usr/bin/env bash

IPNET=192.168.1.0/24
IP=192.168.1.40
GATE=192.168.1.100
NETNAME=docker_dummy
docker network create -d macvlan --subnet=$IPNET --gateway=$GATE -o parent=eth_dummy:eth_dummy1 $NETNAME
docker run -it --rm --network $NETNAME --ip $IP ubuntu-pimped /bin/bash
