# configure s3 bucket for storing state file
resource "aws_s3_bucket" "state" {
    bucket = "cloudvpnstate31"

    /*
    lifecycle {
        prevent_destroy = true
    }
    */
    force_destroy = true
}

# versioning enabled for the bucket
resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.state.bucket

    versioning_configuration {
        status = "Enabled"
    }
}

# Encrypt the data at rest in the s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
    bucket = aws_s3_bucket.state.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Explicitly block the bucket from public access 
resource "aws_s3_bucket_public_access_block" "default" {
    
    bucket = aws_s3_bucket.state.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

