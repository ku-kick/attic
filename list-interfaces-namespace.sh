#!/usr/bin/env bash
lsns

PID=2062
nsenter -t $PID -n ip link show
