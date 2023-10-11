output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = aws_s3_bucket.s3bucket.bucket
}

output "s3_website_url" {
  description = "The S3 endpoint URL."
  value       = aws_s3_bucket_website_configuration.static_website.website_endpoint
}

output "domain_name" {
  description = "The Cloudfront endpoint URL."
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}
