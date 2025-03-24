resource "aws_s3_bucket" "new_bucket" {
  bucket   = "bucket-ed-5015425678442496"
  provider = aws.eu-west
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "imported" {
  bucket   = aws_s3_bucket.new_bucket.id
  provider = aws.eu-west
  versioning_configuration {
    status = "Enabled"
  }
}

# Configure server-side encryption for the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "imported" {
  bucket   = aws_s3_bucket.new_bucket.id
  provider = aws.eu-west

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "imported" {
  bucket   = aws_s3_bucket.new_bucket.id
  provider = aws.eu-west

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
