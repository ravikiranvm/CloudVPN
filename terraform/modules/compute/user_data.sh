#!/bin/bash

# Install aws cli
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Install WireGuard
apt update
apt install -y wireguard

# Set server and client IPs
SERVER_IP="10.16.16.1/24"
CLIENT_IP="10.16.16.2/32"

# Generate server and client keys
SERVER_PRIVATE_KEY=$(wg genkey)
SERVER_PUBLIC_KEY=$(echo $SERVER_PRIVATE_KEY | wg pubkey)
CLIENT_PRIVATE_KEY=$(wg genkey)
CLIENT_PUBLIC_KEY=$(echo $CLIENT_PRIVATE_KEY | wg pubkey)

# Create WireGuard server config
cat <<EOF > /etc/wireguard/wg0.conf
[Interface]
Address = $SERVER_IP
ListenPort = 51820
PrivateKey = $SERVER_PRIVATE_KEY

PostUp = iptables -t nat -A POSTROUTING -o enX0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o enX0 -j MASQUERADE

[Peer]
PublicKey = $CLIENT_PUBLIC_KEY
AllowedIPs = $CLIENT_IP
EOF

# Create WireGuard client config
cat <<EOF > /home/ubuntu/wg-client.conf
[Interface]
Address = $CLIENT_IP
PrivateKey = $CLIENT_PRIVATE_KEY

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
Endpoint = $(curl -s ifconfig.me):51820
AllowedIPs = 0.0.0.0/0, ::/0
EOF

# Set correct permissions
chmod 600 /etc/wireguard/wg0.conf
chmod 600 /home/ubuntu/wg-client.conf

#IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Start and enable WireGuard service
systemctl enable wg-quick@wg0
systemctl start wg-quick@wg0

# Copy client conf file to S3 bucket
sudo aws s3 cp "/home/ubuntu/wg-client.conf" s3://client-vpn-conf-files/
