resource "aws_s3_bucket" "bucket" {
  bucket                 = var.bucket
  tags = {
    "Name"            = var.bucket
    "Service Role"    = "S3 Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
