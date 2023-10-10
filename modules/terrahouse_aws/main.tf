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

data "aws_caller_identity" "current" {
  
}
