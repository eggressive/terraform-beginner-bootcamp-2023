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
  }
}
