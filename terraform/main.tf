provider "aws" {
    region = "ap-southeast-1"
}

# referencing the VPC module

module "vpc" {
    source = "./modules/vpc"
}

# referencing the security group

module "security_group" {
    source = "./modules/security_group"
    vpc_id = module.vpc.vpc_id

}

module "compute" {
    source = "./modules/compute"
    subnet_id        = module.vpc.subnet_id
    security_group_id = module.security_group.security_group_id

}



