resource "aws_s3_bucket" "s3bucket" {
  # we want to assign a random name to the bucket
  #bucket = var.bucket_name

  tags = {
    UserUUID     = var.user_uuid
    Project      = "TerraHouse"
    Name         = "website_bucket"
    Purpose      = "Static Website"
  }
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  bucket = aws_s3_bucket.s3bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "index.html"
  source = var.index_html_filepath   # Replace with the path to your local index.html file
  content_type = "text/html"
  etag = filemd5(var.index_html_filepath)
  lifecycle {
    replace_triggered_by = [ terraform_data.content_version.output]
    ignore_changes = [ etag ]
  }
}

resource "aws_s3_object" "upload_assets" {
  for_each = fileset(var.assets_path, "*.{jpg,png,gif}")

  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "assets/${each.key}"
  source = "${var.assets_path}/${each.key}"
  content_type = "image/jpeg"
  etag = filemd5("${var.assets_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [ terraform_data.content_version.output]
    ignore_changes = [ etag ]
  }
}

resource "aws_s3_object" "website_error" {
  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "error.html"
  source = var.error_html_filepath   # Replace with the path to your local error.html file
  content_type = "text/html"
  etag = filemd5(var.error_html_filepath)
  lifecycle {
    ignore_changes = [ etag ]
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.s3bucket.id

  policy = jsonencode(
  {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipalReadOnly",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.s3bucket.id}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                }
            }
        }
      ]
  })
}

resource "terraform_data" "content_version" {
  input = var.content_version
}
