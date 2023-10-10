variable "user_uuid" {
  type        = string
}

variable "index_html_filepath" {
  description = "The file path of the index.html file."
  type        = string
}

variable "error_html_filepath" {
  description = "The file path of the error.html file."
  type        = string
}

variable "content_version" {
  description = "The version of the content."
  type        = number
}

variable "assets_path" {
  description = "Path to assets folder."
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