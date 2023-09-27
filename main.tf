variable "aws_secret_key" {
  default = ""
}

variable "region" {
  default = "eu-central-1"
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = var.bucket_name

    tags = {
      UserUUID     = var.user_uuid
  }
}
