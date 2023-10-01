# Output definition for the bucket name
output "bucket_name" {
  description = "The name of the S3 bucket for the static website."
  value       = aws_s3_bucket.s3bucket.bucket
}

#output "website_url" {
#  description = "The website endpoint URL."
#  value       = aws_s3_bucket.s3bucket.website_endpoint
#}

output "website_url" {
  description = "The website endpoint URL."
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
