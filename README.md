# Wiredguarduseradd

A simple bash script to automate the addition of new peers to a WireGuard VPN server. The script generates the necessary keys, creates a configuration for the new user, and appends the peer information to the server's configuration.

Features:

* Automatically generate private and public keys for new users.
* Prompt the user for server-specific information like the server's public key and endpoint.
* Optionally allow manual IP address assignment or automate it based on existing peers.
* Create a user-specific configuration file for easy distribution.
* Update the server's configuration and synchronize the changes.

Usage:

chmod +x user_add_wireguard
sudo ./user_add_wireguard

When running, the script will ask for the server's public key, endpoint, and optionally the user's desired IP address. If no IP address is provided, it will automatically assign the next available one.

