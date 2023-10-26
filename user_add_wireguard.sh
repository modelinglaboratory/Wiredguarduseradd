#!/bin/bash

# Check if wg command exists (WireGuard tools)
if ! command -v wg &> /dev/null; then
    echo "WireGuard is not installed. Installing now..."
    
    # Assuming you are using a Debian-based system
    sudo apt update
    sudo apt install -y wireguard wireguard-tools
fi

# Path to WireGuard configuration file
WG_CONFIG="/etc/wireguard/wg0.conf"

# If the WireGuard configuration file doesn't exist, create it
if [ ! -f "$WG_CONFIG" ]; then
    echo "[Interface]
Address = 10.0.0.1/24
ListenPort = 51820
PrivateKey = $(wg genkey)" > $WG_CONFIG

    # Enable and start the WireGuard service
    sudo systemctl enable wg-quick@wg0
    sudo systemctl start wg-quick@wg0
fi

# Get the server's public key and endpoint information from the user
read -p "Server's Public Key: " SERVER_PUBLIC_KEY
read -p "Server's Endpoint Information (e.g., example.com:51820): " SERVER_ENDPOINT

# Generate user's private and public keys
PRIVATE_KEY=$(wg genkey)
PUBLIC_KEY=$(echo "$PRIVATE_KEY" | wg pubkey)

# Determine the user's IP address (in this example, it's in the format 10.0.0.X)
read -p "User IP Address (leave empty for automatic assignment, e.g., 10.0.0.5): " CLIENT_IP
if [ -z "$CLIENT_IP" ]; then
    LAST_IP=$(grep AllowedIPs $WG_CONFIG | awk -F'.' '{print $4}' | awk -F'/' '{print $1}' | sort -n | tail -1)
    CLIENT_IP="10.0.0.$((LAST_IP + 1))"
fi

# Add the new user to the server configuration file
echo -e "\n[Peer]
PublicKey = $PUBLIC_KEY
AllowedIPs = $CLIENT_IP/32" >> $WG_CONFIG

# Restart the server
wg syncconf wg0 <(wg-quick strip wg0)

echo "New user successfully added to the server. Now, displaying client configuration."

# Display client configuration details
echo -e "\n[Interface]
PrivateKey = $PRIVATE_KEY
Address = $CLIENT_IP/32
DNS = 10.0.0.1

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_ENDPOINT
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25"

