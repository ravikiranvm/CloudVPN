
# Create EC2 instance to use Wireguard

resource "aws_instance" "wireguard_instance" {
    ami = "ami-047126e50991d067b"
    instance_type = "t2.micro"
    subnet_id = var.subnet_id
    key_name = "CloudVPNInstanceKey"
    
    #security_groups = [var.security_group_id] # security_groups is for classic ec2 and default vpc only
    vpc_security_group_ids = [var.security_group_id]

    associate_public_ip_address = true

    # User Data (providing the port and endpoint dynamically)

    user_data = <<-EOT
                #!/bin/bash
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

                # Start and enable WireGuard service
                systemctl enable wg-quick@wg0
                systemctl start wg-quick@wg0
                EOT

}


# Output instance public IP (to be used for client config)
  output "ec2_public_ip" {
    value = aws_instance.wireguard_instance.public_ip
  }


