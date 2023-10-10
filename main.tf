terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "terratowns" {
  endpoint  = "https://terratowns.cloud/api"
  user_uuid = "ff165866-9be8-43db-af1a-662476f05177"
  token     = "7fc43df3-5c5c-4446-8087-33b4bbb36db7"
}

resource "terratowns_home" "home" {
  name = "The Matrix"
  description = <<-EOF
  Dedicated to the the iconic sci-fi action film, The Matrix.
  Here, you can learn about the movie's groundbreaking special effects,
  its thought-provoking philosophical themes, and its enduring cultural impact.
EOF
  town = "missingo"
  #domain_name = module.terrahouse_aws.cdn_website_url
  domain_name = "something1.cloudfront.net"
  content_version = 1
}


/* module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_path = var.assets_path
} */