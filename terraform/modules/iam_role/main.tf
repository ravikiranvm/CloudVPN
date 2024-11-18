resource "aws_iam_role" "s3_access_role" {
    name = "s3_access_role"

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
            Action = "sts:AssumeRole"
        }]
    })
  
}

resource "aws_iam_instance_profile" "accessS3" {
    name = "accessS3"
    role = aws_iam_role.s3_access_role.name
}

output "instance_profile_name" {
    value = aws_iam_instance_profile.accessS3.name
}

output "instance_profile_arn" {
    value = aws_iam_instance_profile.accessS3.arn
}

output "role_name" {
    value = aws_iam_role.s3_access_role.name
}

output "role_arn" {
    value = aws_iam_role.s3_access_role.arn
}

