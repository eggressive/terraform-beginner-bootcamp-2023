output "bucket_name" {
  description = "The name of the S3 bucket for the static website."
  value       = module.terrahouse_aws.bucket_name
}

output "s3_website_url" {
  value       = "http://${module.terrahouse_aws.s3_website_url}"
  description = "The website endpoint URL."
}

output "cdn_website_url" {
  value       = "http://${module.terrahouse_aws.cdn_website_url}"
  description = "The website endpoint URL."
}