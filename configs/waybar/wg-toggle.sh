#!/bin/bash

# WireGuard interface name
WG_INTERFACE="i_lenovo"

# Check if interface is up
if ip link show "$WG_INTERFACE" &> /dev/null; then
    # Interface is up - disconnect
    sudo wg-quick down "$WG_INTERFACE"
else
    # Interface is down - connect
    sudo wg-quick up "$WG_INTERFACE"
fi

