output "arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "The s3 bucket arn"
}
output "bucket_name" {
  value       = aws_s3_bucket.bucket.bucket
  description = "The s3 bucket name"
}

