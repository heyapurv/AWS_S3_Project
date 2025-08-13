provider "aws" {
  region = "us-east-1"
}

# Generate a random suffix for uniqueness
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Create S3 bucket with unique name
resource "aws_s3_bucket" "static_site" {
  bucket = "heyapurv-static-site-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.static_site.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.static_site.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_site.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action   = ["s3:GetObject"]
        Resource = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}

# Output bucket name for Jenkins
output "bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}

# Output website endpoint
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}
