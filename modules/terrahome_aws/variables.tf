variable "aws_secret_key" {
  default = ""
}

variable "aws_access_key" {
  default = ""
}

variable "region" {
  default = "eu-central-1"
}

variable "user_uuid" {
  description = "UUID of the user."
  type        = string

  validation {
    condition     = can(regex("^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$", var.user_uuid))
    error_message = "The user_uuid must be a valid UUID."
  }
}

/* variable "matrix" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "starwars" {
  type = object({
    public_path = string
    content_version = number
  })
} */

variable "content_version" {
  description = "The version of the website content."
  type        = number
  
  validation {
    condition     = var.content_version >= 1 && floor(var.content_version) == var.content_version
    error_message = "The content_version must be a positive integer starting at 1."
  }
}

variable "public_path" {
  description = "The file path for the public directory"
  type        = string
}