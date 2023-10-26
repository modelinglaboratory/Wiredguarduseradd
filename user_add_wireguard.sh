#!/bin/bash

# Path to WireGuard configuration file
WG_CONFIG="/etc/wireguard/wg0.conf"

# Get the server's public key and endpoint information from the user
read -p "Server's Public Key: " SERVER_PUBLIC_KEY
read -p "Server's Endpoint Information (e.g., example.com:51820): " SERVER_ENDPOINT

# Generate user's private and public keys
PRIVATE_KEY=$(wg genkey)
PUBLIC_KEY=$(echo "$PRIVATE_KEY" | wg pubkey)

# Determine the user's IP address (in this example, it's in the format 10.0.0.X)
# Optionally get the IP address from the user
read -p "User IP Address (leave empty for automatic assignment, e.g., 10.0.0.5): " CLIENT_IP

# If the user IP address is not specified, assign it automatically
if [ -z "$CLIENT_IP" ]; then
    LAST_IP=$(grep AllowedIPs $WG_CONFIG | awk -F'.' '{print $4}' | awk -F'/' '{print $1}' | sort -n | tail -1)
    CLIENT_IP="10.0.0.$((LAST_IP + 1))"
fi

# Create the WireGuard configuration for the new user
echo "[Interface]
PrivateKey = $PRIVATE_KEY
Address = $CLIENT_IP/32
DNS = 10.0.0.1

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $SERVER_ENDPOINT
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25" > "$CLIENT_IP-wg0.conf"

# Add the new user to the server configuration file
echo -e "\n[Peer]
PublicKey = $PUBLIC_KEY
AllowedIPs = $CLIENT_IP/32" >> $WG_CONFIG

# Restart the server
wg syncconf wg0 <(wg-quick strip wg0)

echo "New user successfully added. Configuration file: $CLIENT_IP-wg0.conf"

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

