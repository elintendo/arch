#!/usr/bin/env bash
# WireGuard VPN toggle script for Waybar

INTERFACE="i_lenovo"

# Check if WireGuard interface is up
check_status() {
    if sudo wg show "$INTERFACE" &>/dev/null; then
        echo '{"text": "🔒", "tooltip": "VPN Connected: '"$INTERFACE"'", "class": "connected"}'
    else
        echo '{"text": "🔓", "tooltip": "VPN Disconnected", "class": "disconnected"}'
    fi
}

# Toggle VPN connection
toggle_vpn() {
    if sudo wg show "$INTERFACE" &>/dev/null; then
        sudo wg-quick down "$INTERFACE"
        notify-send "VPN" "Disconnected from $INTERFACE" -i network-vpn-disconnected
    else
        sudo wg-quick up "$INTERFACE"
        notify-send "VPN" "Connected to $INTERFACE" -i network-vpn
    fi
}

# Handle different actions
case "$1" in
    toggle)
        toggle_vpn
        ;;
    *)
        check_status
        ;;
esac

