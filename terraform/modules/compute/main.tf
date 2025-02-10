
# Create EC2 instance to use Wireguard

resource "aws_instance" "wireguard_instance" {
    ami = "ami-047126e50991d067b"
    instance_type = "t2.micro"
    subnet_id = var.subnet_id
    key_name = "CloudVPNInstanceKey"

    iam_instance_profile = var.instance_profile_name
    
    #security_groups = [var.security_group_id] # security_groups is for classic ec2 and default vpc only
    vpc_security_group_ids = [var.security_group_id]

    associate_public_ip_address = true

    # User Data (providing the port and endpoint dynamically)

    user_data = file("${path.module}/user_data.sh")

}


# Output instance public IP (to be used for client config)
  output "ec2_public_ip" {
    value = aws_instance.wireguard_instance.public_ip
  }


