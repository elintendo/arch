#!/bin/bash
# VPN Network Namespace Manager
# Run browser (or any app) in isolated network namespace with VPN

set -e

NAMESPACE="vpn_ns"
VPN_INTERFACE="i_lenovo"
VETH_HOST="veth_host"
VETH_NS="veth_ns"
VETH_ADDR="10.200.200.1"
NS_ADDR="10.200.200.2"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        print_error "Please run as root (use sudo)"
        exit 1
    fi
}

# Create and setup the network namespace
setup_namespace() {
    print_info "Creating network namespace: $NAMESPACE"
    
    # Create namespace
    ip netns add "$NAMESPACE" 2>/dev/null || true
    
    # Create veth pair
    print_info "Creating veth pair for namespace communication"
    ip link add "$VETH_HOST" type veth peer name "$VETH_NS" 2>/dev/null || true
    
    # Move one end to namespace
    ip link set "$VETH_NS" netns "$NAMESPACE"
    
    # Configure host side
    ip addr add "$VETH_ADDR/24" dev "$VETH_HOST" 2>/dev/null || true
    ip link set "$VETH_HOST" up
    
    # Configure namespace side
    ip netns exec "$NAMESPACE" ip addr add "$NS_ADDR/24" dev "$VETH_NS"
    ip netns exec "$NAMESPACE" ip link set "$VETH_NS" up
    ip netns exec "$NAMESPACE" ip link set lo up
    
    # Set default route in namespace to point to host
    ip netns exec "$NAMESPACE" ip route add default via "$VETH_ADDR"
    
    # Enable IP forwarding
    sysctl -w net.ipv4.ip_forward=1 > /dev/null
    
    # Setup NAT for initial DNS resolution (before VPN is up)
    iptables -t nat -A POSTROUTING -s "$NS_ADDR/24" -o $(ip route | grep default | awk '{print $5}') -j MASQUERADE 2>/dev/null || true
    
    print_info "Namespace setup complete"
}

# Start VPN in namespace
start_vpn() {
    print_info "Starting WireGuard VPN in namespace..."
    
    # Check if VPN config exists
    if [ ! -f "/etc/wireguard/$VPN_INTERFACE.conf" ]; then
        print_error "WireGuard config not found: /etc/wireguard/$VPN_INTERFACE.conf"
        exit 1
    fi
    
    # Start WireGuard in namespace
    ip netns exec "$NAMESPACE" wg-quick up "$VPN_INTERFACE"
    
    print_info "VPN started successfully in namespace"
    
    # Show VPN status
    print_info "VPN Status:"
    ip netns exec "$NAMESPACE" wg show "$VPN_INTERFACE"
}

# Stop VPN in namespace
stop_vpn() {
    print_info "Stopping VPN in namespace..."
    ip netns exec "$NAMESPACE" wg-quick down "$VPN_INTERFACE" 2>/dev/null || true
}

# Cleanup namespace
cleanup_namespace() {
    print_info "Cleaning up namespace..."
    
    # Stop VPN
    stop_vpn
    
    # Remove veth pair
    ip link delete "$VETH_HOST" 2>/dev/null || true
    
    # Delete namespace
    ip netns delete "$NAMESPACE" 2>/dev/null || true
    
    # Clean up iptables rules
    iptables -t nat -D POSTROUTING -s "$NS_ADDR/24" -o $(ip route | grep default | awk '{print $5}') -j MASQUERADE 2>/dev/null || true
    
    print_info "Cleanup complete"
}

# Run command in namespace
run_in_namespace() {
    local user="$1"
    shift
    local cmd="$@"
    local user_home=$(getent passwd "$user" | cut -d: -f6)
    
    print_info "Running command in VPN namespace as user $user"
    print_info "Command: $cmd"
    
    # Get display from current environment
    local display="${DISPLAY:-:0}"
    local xauthority="${XAUTHORITY:-$user_home/.Xauthority}"
    
    # Run as specific user in namespace with proper environment
    ip netns exec "$NAMESPACE" sudo -u "$user" env \
        HOME="$user_home" \
        DISPLAY="$display" \
        XAUTHORITY="$xauthority" \
        $cmd
}

# Launch browser in namespace
launch_browser() {
    local user="${SUDO_USER:-$USER}"
    local browser="${1:-firefox}"
    local user_home=$(getent passwd "$user" | cut -d: -f6)
    
    print_info "Launching $browser in VPN namespace..."
    
    # Get display from user environment
    local display="${DISPLAY:-:0}"
    local xauthority="${XAUTHORITY:-$user_home/.Xauthority}"
    
    # Launch browser with separate profile to avoid conflicts
    case "$browser" in
        firefox)
            local firefox_profile="$user_home/.mozilla/firefox-vpn"
            # Create profile directory if it doesn't exist
            if [ ! -d "$firefox_profile" ]; then
                print_info "Creating Firefox VPN profile directory..."
                sudo -u "$user" mkdir -p "$firefox_profile"
            fi
            # Launch Firefox with no-remote to allow running alongside normal Firefox
            ip netns exec "$NAMESPACE" sudo -u "$user" env DISPLAY="$display" XAUTHORITY="$xauthority" \
                firefox --no-remote --profile "$firefox_profile" &
            ;;
        chromium)
            local chromium_profile="$user_home/.config/chromium-vpn"
            sudo -u "$user" mkdir -p "$chromium_profile"
            ip netns exec "$NAMESPACE" sudo -u "$user" env DISPLAY="$display" XAUTHORITY="$xauthority" \
                chromium --user-data-dir="$chromium_profile" &
            ;;
        brave)
            local brave_profile="$user_home/.config/brave-vpn"
            sudo -u "$user" mkdir -p "$brave_profile"
            ip netns exec "$NAMESPACE" sudo -u "$user" env DISPLAY="$display" XAUTHORITY="$xauthority" \
                brave --user-data-dir="$brave_profile" &
            ;;
        *)
            ip netns exec "$NAMESPACE" sudo -u "$user" env DISPLAY="$display" XAUTHORITY="$xauthority" \
                "$browser" &
            ;;
    esac
    
    local browser_pid=$!
    print_info "Browser launched in VPN namespace (PID: $browser_pid)"
    print_warning "This browser can ONLY access internet through VPN"
    print_warning "If VPN disconnects, browser will lose all connectivity"
}

# Check namespace status
check_status() {
    print_info "Checking namespace status..."
    
    if ip netns list | grep -q "$NAMESPACE"; then
        print_info "Namespace '$NAMESPACE' exists"
        
        # Check if VPN is running
        if ip netns exec "$NAMESPACE" ip link show "$VPN_INTERFACE" &>/dev/null; then
            print_info "VPN interface '$VPN_INTERFACE' is UP"
            echo ""
            ip netns exec "$NAMESPACE" wg show "$VPN_INTERFACE" 2>/dev/null || print_warning "WireGuard not active"
        else
            print_warning "VPN interface '$VPN_INTERFACE' is DOWN"
        fi
        
        # Show IP addresses
        echo ""
        print_info "IP addresses in namespace:"
        ip netns exec "$NAMESPACE" ip addr show
        
        # Show routing table
        echo ""
        print_info "Routing table in namespace:"
        ip netns exec "$NAMESPACE" ip route show
    else
        print_warning "Namespace '$NAMESPACE' does not exist"
    fi
}

# Test connectivity in namespace
test_connection() {
    print_info "Testing connectivity in namespace..."
    
    if ! ip netns list | grep -q "$NAMESPACE"; then
        print_error "Namespace does not exist. Run 'setup' first."
        exit 1
    fi
    
    # Test DNS
    print_info "Testing DNS resolution..."
    ip netns exec "$NAMESPACE" nslookup google.com || print_warning "DNS resolution failed"
    
    # Test connectivity
    print_info "Testing connectivity..."
    ip netns exec "$NAMESPACE" ping -c 3 8.8.8.8 || print_warning "Ping failed"
    
    # Check external IP
    print_info "Checking external IP address..."
    ip netns exec "$NAMESPACE" curl -s ifconfig.me || print_warning "Could not determine IP"
    echo ""
}

# Show usage
show_usage() {
    cat << EOF
VPN Network Namespace Manager

Usage: sudo $0 <command> [options]

Commands:
    setup               Create namespace and start VPN
    teardown            Stop VPN and remove namespace
    status              Check namespace and VPN status
    test                Test connectivity in namespace
    browser [name]      Launch browser in namespace (default: firefox)
                        Supported: firefox, chromium, brave, or any command
    exec <cmd>          Execute command in namespace as current user
    shell               Open shell in namespace

Examples:
    sudo $0 setup
    sudo $0 browser firefox
    sudo $0 browser chromium
    sudo $0 exec "curl ifconfig.me"
    sudo $0 shell
    sudo $0 status
    sudo $0 teardown

Note: The namespace provides complete network isolation. Applications can
      ONLY access the internet through the VPN. If VPN drops, all connectivity
      is lost (preventing leaks).

EOF
}

# Main script logic
main() {
    case "${1:-}" in
        setup)
            check_root
            cleanup_namespace  # Clean up any existing setup
            setup_namespace
            start_vpn
            print_info "Setup complete! Use '$0 browser' to launch browser"
            ;;
        teardown|cleanup|down)
            check_root
            cleanup_namespace
            ;;
        status)
            check_root
            check_status
            ;;
        test)
            check_root
            test_connection
            ;;
        browser)
            check_root
            launch_browser "${2:-firefox}"
            ;;
        exec)
            check_root
            shift
            run_in_namespace "${SUDO_USER:-$USER}" "$@"
            ;;
        shell)
            check_root
            local user="${SUDO_USER:-$USER}"
            local user_home=$(getent passwd "$user" | cut -d: -f6)
            print_info "Opening shell in VPN namespace..."
            ip netns exec "$NAMESPACE" sudo -u "$user" env HOME="$user_home" bash
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
}

main "$@"

