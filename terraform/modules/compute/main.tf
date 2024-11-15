


# Create EC2 instance to use Wireguard

resource "aws_instance" "wireguard_instance" {
    ami = "ami-07c9c7aaab42cba5a"
    instance_type = "t2.micro"
    subnet_id = var.subnet_id
    security_groups = [var.security_group_id] 


    associate_public_ip_address = true

    user_data = <<-EOF
              #!/bin/bash
              echo "EC2 instance launched successfully at $(date)" > /var/log/instance_launch.log
              EOF

}

