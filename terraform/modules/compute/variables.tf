# variables.tf (inside compute module)
variable "subnet_id" {
  description = "The subnet ID for the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the EC2 instance"
  type        = string
}

variable instance_profile_name {
  description = "Instance profile to access s3"
  type = string
}