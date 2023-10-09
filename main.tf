terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

provider "terratowns" {
  endpoint  = "http://localhost:4567/api"
  user_uuid = "e328f4ab-b99f-421c-84c9-4ccea042c7d1"
  token     = "9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

resource "terratowns_home" "home" {
  name = "The Matrix 1999"
  description = <<-EOF
  Dedicated to the the iconic sci-fi action film, The Matrix.
  Here, you can learn about the movie's groundbreaking special effects,
  its thought-provoking philosophical themes, and its enduring cultural impact.
EOF
  town = "video-valley"
  #domain_name = module.terrahouse_aws.cdn_website_url
  domain_name = "something.cloudfront.net"
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