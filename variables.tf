variable "user_uuid" {
  type        = string
}

variable "terratowns_endpoint" {
  description = "The endpoint of the Terratowns API."
  type        = string
}

variable "terratowns_access_token" {
 type = string
 description = "value of the access token"
}

variable "matrix" {
  type = object({
    public_path = string
    content_version = number
  })
}

variable "starwars" {
  type = object({
    public_path = string
    content_version = number
  })
}
