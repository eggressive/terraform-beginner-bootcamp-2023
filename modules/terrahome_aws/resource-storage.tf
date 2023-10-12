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
  source = "${var.public_path}/index.html"
  content_type = "text/html"

  etag = filemd5("${var.public_path}/index.html")
  lifecycle {
    replace_triggered_by = [ terraform_data.content_version.output]
    ignore_changes = [ etag ]
  }
}

resource "aws_s3_object" "upload_assets" {
  for_each = fileset("${var.public_path}/assets", "*.{jpg,png,gif,mp3}")
  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "assets/${each.key}"
  source = "${var.public_path}/assets/${each.key}"
    content_type = lookup({
    jpg = "image/jpeg"
    png = "image/png"
    gif = "image/gif"
    mp3 = "audio/mpeg"
  }, lower(replace(each.key, "^.+\\.", "")), "binary/octet-stream")
  etag = filemd5("${var.public_path}/assets/${each.key}")
  lifecycle {
    replace_triggered_by = [ terraform_data.content_version.output]
    ignore_changes = [ etag ]
  }
}

resource "aws_s3_object" "website_error" {
  bucket = aws_s3_bucket.s3bucket.bucket
  key    = "error.html"
  source = "${var.public_path}/error.html"
  content_type = "text/html"
  etag = filemd5("${var.public_path}/error.html")
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
