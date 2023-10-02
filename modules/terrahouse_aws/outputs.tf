# Output definition for the bucket name
output "bucket_name" {
  description = "The name of the S3 bucket for the static website."
  value       = aws_s3_bucket.s3bucket.bucket
}

output "s3_website_url" {
  description = "The S3 endpoint URL."
  value       = aws_s3_bucket.s3bucket.website_endpoint
}

output "cdn_website_url" {
  description = "The Cloudfront endpoint URL."
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
