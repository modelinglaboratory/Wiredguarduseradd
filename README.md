# Wiredguarduseradd

A simple bash script to automate the addition of new peers to a WireGuard VPN server. The script generates the necessary keys, creates a configuration for the new user, and appends the peer information to the server's configuration.

## Features

* Automatically generate private and public keys for new users.
* Prompt the user for server-specific information like the server's public key and endpoint.
* Optionally allow manual IP address assignment or automate it based on existing peers.
* Create a user-specific configuration file for easy distribution.
* Update the server's configuration and synchronize the changes.

## Usage

This repository provides scripts for automatic user addition to a WireGuard VPN server on Debian 12.

## Automatic Installation and Execution

Follow these steps to automatically download and run the script on a computer with Debian 12:

### 1. Update Packages and Install Necessary Tools

First, check if `git` is installed and install any missing packages.

```bash
sudo apt update
sudo apt install git -y
```

### 2. Download the Installation Script

The user can directly download the installation script (in this case, `install_and_run.sh`). If this script is available on the GitHub repository, it can be directly fetched using `wget` or `curl`.

[Download using wget](https://raw.githubusercontent.com/modelinglaboratory/Wiredguarduseradd/main/install_and_run.sh)
```bash
wget https://raw.githubusercontent.com/modelinglaboratory/Wiredguarduseradd/main/install_and_run.sh
```

or

[Download using curl](https://raw.githubusercontent.com/modelinglaboratory/Wiredguarduseradd/main/install_and_run.sh)
```bash
curl -O https://raw.githubusercontent.com/modelinglaboratory/Wiredguarduseradd/main/install_and_run.sh
```

### 3. Make the Script Executable

Make the downloaded script executable:

```bash
chmod +x install_and_run.sh
```

### 4. Run the Script

Now, run the installation script to automatically download and execute the `user_add_wireguard.sh` script:

```bash
./install_and_run.sh
```

**Important Note**: Users should always review the contents of scripts they download and ensure they are downloading scripts from trusted sources. This is especially crucial for scripts that automate downloads and installations.
```


When running, the script will ask for the server's public key, endpoint, and optionally the user's desired IP address. If no IP address is provided, it will automatically assign the next available one.

