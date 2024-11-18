resource "aws_iam_policy" "s3_access_policy" {
    name = "s3_access_policy"
    #role = var.role_name

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "s3:PutObject"
            Effect = "Allow"
            Resource = "${var.bucket_arn}/*"

        }]
    })
}

output "policy_arn" {
    value = aws_iam_policy.s3_access_policy.arn 
}
