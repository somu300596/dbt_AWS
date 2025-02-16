output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.my-bucket.arn
}
