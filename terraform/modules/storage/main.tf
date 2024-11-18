resource "aws_s3_bucket" "client-vpn-conf-files" {
    bucket = "client-vpn-conf-files"
    force_destroy = true

}

output "bucket_id" {
    value = aws_s3_bucket.client-vpn-conf-files.id
}

output "bucket_arn" {
    value = aws_s3_bucket.client-vpn-conf-files.arn
}