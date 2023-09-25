variable "aws_secret_key" {
  default = ""
}

variable "region" {
  default = "eu-central-1"
}

resource "random_string" "bucket_name" {
  length           = 10
  upper            = false
  special          = true
  override_special = "-"
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = random_string.bucket_name.result

    tags = {
      UserUUID     = var.user_uuid
  }
}
