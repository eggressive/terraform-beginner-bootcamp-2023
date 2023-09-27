# Output definition for the bucket name
output "bucket_name" {
  description = "The name of the created S3 bucket."
  value       = aws_s3_bucket.s3bucket.bucket
}
