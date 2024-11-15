# Create a custom VPC

resource "aws_vpc" "custom_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true
}

# Create a public subnet in the custom vpc

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.custom_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-southeast-1a"
}

# Create an Internet Gateway for the custome vpc

resource "aws_internet_gateway" "custom_igw" {
    vpc_id = aws_vpc.custom_vpc.id
}

# Create a route table for custom VPC

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.custom_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.custom_igw.id
    }
}

# Associate the public route table to the public subnet

resource "aws_route_table_association" "public_route_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}




# Outputs

output "vpc_id" {
    value = aws_vpc.custom_vpc.id
}

output "subnet_id" {
    value = aws_subnet.public_subnet.id
}

