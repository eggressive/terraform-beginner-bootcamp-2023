output "bucket_name" {
  description = "The name of the S3 bucket for the static website."
  value       = module.terrahouse_aws.bucket_name
}