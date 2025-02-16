resource "aws_s3_bucket" "my-bucket" {
  bucket = var.bucket_name

}

resource "aws_s3_bucket_versioning" "my-bucket-versioning" {
  bucket = aws_s3_bucket.my-bucket.id

  versioning_configuration {
    status = "Enabled"  # You can use "Suspended" if you want to disable versioning
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my-bucket-encryption" {
  bucket = aws_s3_bucket.my-bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "my-bucket" {
  bucket                  = aws_s3_bucket.my-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
