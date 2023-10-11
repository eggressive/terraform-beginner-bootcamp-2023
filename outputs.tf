output "bucket_name" {
  description = "The name of the S3 bucket."
  value       = "${module.home_matrix_hosting.bucket_name}"
}

output "s3_website_url" {
  value       = "${module.home_matrix_hosting.s3_website_url}"
  description = "The S3 bucket endpoint URL."
}

output "domain_name" {
  value       = "http://${module.home_matrix_hosting.domain_name}"
  description = "The Cloudfront endpoint URL."
}
