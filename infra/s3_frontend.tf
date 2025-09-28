provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "frontend" {
  bucket = "cloud-mailbox-frontend-${random_id.suffix.hex}"

  force_destroy = true # Should not be used in production!

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

# Generate a random suffix for the S3 bucket name to ensure uniqueness
resource "random_id" "suffix" {
  byte_length = 4
}

### Upload the frontend file to the S3 bucket ###
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.frontend.id
  key    = "index.html"
  source = "${path.module}/../frontend/index.html"
  depends_on = [aws_s3_bucket.frontend]
}

resource "aws_s3_bucket_ownership_controls" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket                  = aws_s3_bucket.frontend.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "frontend_public" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject"]
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}
