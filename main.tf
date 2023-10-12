terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "eggressive"

  workspaces {
    name = "terra-house-1"
    }
  }    
}

provider "terratowns" {
  endpoint  = var.terratowns_endpoint
  user_uuid = var.user_uuid
  token     = var.terratowns_access_token
}

module "home_matrix_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.user_uuid
  public_path = var.matrix.public_path
  content_version = var.matrix.content_version
}

resource "terratowns_home" "home_matrix" {
  name = "The Matrix"
  description = <<-EOF
  Dedicated to the the iconic sci-fi action film, The Matrix.
  Here, you can learn about the movie's groundbreaking special effects,
  its thought-provoking philosophical themes, and its enduring cultural impact.
EOF
  town = "video-valley"
  domain_name = module.home_matrix_hosting.domain_name
  content_version = var.matrix.content_version
}

module "home_starwars_hosting" {
  source = "./modules/terrahome_aws"
  user_uuid = var.user_uuid
  public_path = var.starwars.public_path
  content_version = var.starwars.content_version
}

resource "terratowns_home" "home_starwars" {
  name = "The Star Wars Saga"
  description = <<-EOF
  The Star Wars saga is a space opera epic created by George Lucas and centered on the Skywalker family. 
  It spans nine main episodic films, two anthology films, and various television series, 
  novels, comic books, video games, and other media.
EOF
  town = "missingo"
  domain_name = module.home_starwars_hosting.domain_name
  content_version = var.starwars.content_version
}

