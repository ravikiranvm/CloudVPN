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
    instance_profile_name = module.iam_role.instance_profile_name

}

module "storage" {
    source = "./modules/storage"
}

module "iam_role" {
    source = "./modules/iam_role"
}

module "iam_policy" {
    source = "./modules/iam_policy"
    bucket_arn = module.storage.bucket_arn
    role_name = module.iam_role.role_name

}

resource "aws_iam_role_policy_attachment" "s3AccessToEC2" {
    role = module.iam_role.role_name
    policy_arn = module.iam_policy.policy_arn
}



