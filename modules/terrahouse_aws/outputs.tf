# Output definition for the bucket name
output "bucket_name" {
  description = "The name of the S3 bucket for the static website."
  value       = aws_s3_bucket.s3bucket.bucket
}