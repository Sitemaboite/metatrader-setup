# How to connect

## 1. VPN configuration
After full setup or vnc setup, your server will be accessible through a VPN. You can connect to the VPN by following the instructions below.

### 1.1. Install Wireguard
You can install Wireguard by following the instructions on the [official website](https://www.wireguard.com/install/).

### 1.2. Download the configuration file
You can download the configuration file by running the following command:
```bash
scp root@<server_ip>:/etc/wireguard/clients/<username>.conf .
```
for SCP on Windows, you can use [WinSCP](https://winscp.net/eng/download.php).

### 1.3. Use the configuration file
You can use the configuration file to connect to the VPN by following the instructions on the [Hetzner documentation](https://community.hetzner.com/tutorials/install-and-configure-wireguard-vpn#step-32---android-client).

### 1.4. Connect to the VPN
After following the instructions above, you should be able to connect to the VPN.

### 2. Install VNC client
We recommend using [TigerVNC](https://sourceforge.net/projects/tigervnc/files/stable/1.15.0/) for better experience.

### 2.1 Connect to the server
The server ip is 10.0.0.1 and the port is given during the setup.