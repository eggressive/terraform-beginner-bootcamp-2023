variable "bucket_name" {
  type        = string
}

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