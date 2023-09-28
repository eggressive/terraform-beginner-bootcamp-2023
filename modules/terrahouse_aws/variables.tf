variable "aws_secret_key" {
  default = ""
}

variable "aws_access_key" {
  default = ""
}

variable "region" {
  default = "eu-central-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string

  validation {
    condition = (
      length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9](?:[a-z0-9.-]{1,61}[a-z0-9])?$", var.bucket_name)) &&
      !can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.bucket_name))
    )
    error_message = "The bucket_name must be between 3 and 63 characters, can contain only lowercase letters, numbers, hyphens, and periods, must start and end with a lowercase letter or number, and cannot be formatted as IP address."
  }
}

variable "user_uuid" {
  description = "UUID of the user."
  type        = string

  validation {
    condition     = can(regex("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$", var.user_uuid))
    error_message = "The user_uuid must be a valid UUID."
  }
}