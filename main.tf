terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.user_uuid
  token     = var.terratowns_access_token
}

resource "terratowns_home" "home" {
  name = "The Matrix"
  description = <<-EOF
  Dedicated to the the iconic sci-fi action film, The Matrix.
  Here, you can learn about the movie's groundbreaking special effects,
  its thought-provoking philosophical themes, and its enduring cultural impact.
EOF
  town = "missingo"
  domain_name = module.terrahouse_aws.cdn_website_url
  #domain_name = "test212.cloudfront.net"
  content_version = 1
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
}