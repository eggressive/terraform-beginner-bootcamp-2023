terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.18.0"
    }
  }
#  cloud {
#    organization = "eggressive"
#
#  workspaces {
#    name = "terra-house-eggressive"
#    }
#  }    
}

provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = var.bucket_name

    tags = {
      UserUUID     = var.user_uuid
      Project      = "TerraHouse"
      Name         = "website_bucket"
      Purpose      = "Static Website"
  }
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.s3bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "index.html"
  source = var.index_html_filepath   # Replace with the path to your local index.html file
  content_type = "text/html"
  etag = filemd5(var.index_html_filepath)
  #acl    = "public-read"
}

resource "aws_s3_object" "website_error" {
  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "error.html"
  source = var.error_html_filepath   # Replace with the path to your local error.html file
  content_type = "text/html"
  etag = filemd5(var.error_html_filepath)
  #acl    = "public-read"
}