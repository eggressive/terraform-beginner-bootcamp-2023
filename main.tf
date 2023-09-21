terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
  cloud {
    organization = "eggressive"

  workspaces {
    name = "terra-house-eggressive"
    }
  }    
}

provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
provider "random" {
  # Configuration options
}

variable "aws_access_key" {
  default = ""
}

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
  override_special = "-."
}

resource "aws_s3_bucket" "s3bucket" {
  bucket = random_string.bucket_name.result
}

output "random_bucket_name" {
  value = random_string.bucket_name.result
}
