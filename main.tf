locals {
  bucket = lower(var.bucket) 
}

resource "aws_s3_bucket" "bucket" {
  bucket                 = local.bucket
  tags = {
    "Name"            = local.bucket
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

resource "aws_s3_bucket_policy" "bucket_policy" {
  count = length(compact(data.aws_iam_policy_document.combined_policy.source_policy_documents))
  bucket = aws_s3_bucket.bucket.bucket
  policy = data.aws_iam_policy_document.combined_policy.json
}

data "aws_iam_policy_document" "force_ssl_only" {
  statement {
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = ["s3:*"]
    resources = ["arn:aws:s3:::${var.bucket}/*"]
    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = ["false"]
    }
  }
}

data "aws_iam_policy_document" "deny_unencrypted_object_upload" {
  statement {
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.bucket}/*"]
    condition {
      test = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values = ["true"]
    }
  }
}

data "aws_iam_policy_document" "react" {
  statement {
    effect = "allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = ["s3:PutObject", "s3:GetObject", "s3:List*"]
    resources = ["arn:aws:s3:::${local.bucket}/*"]
  }
}

data "aws_iam_policy_document" "combined_policy" {
  source_policy_documents = compact([
    data.aws_iam_policy_document.force_ssl_only.json,
    data.aws_iam_policy_document.deny_unencrypted_object_upload.json,
    contains(var.polices,"react") ? data.aws_iam_policy_document.react.json : ""
  ])
}
