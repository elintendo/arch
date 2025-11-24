#!/bin/bash

# WireGuard interface name
WG_INTERFACE="i_lenovo"

# Check if interface is up
if ip link show "$WG_INTERFACE" &> /dev/null; then
    echo '{"text": "🔒", "class": "connected", "tooltip": "VPN Connected ('$WG_INTERFACE')"}'
else
    echo '{"text": "🔓", "class": "disconnected", "tooltip": "VPN Disconnected (Click to connect)"}'
fi

