# Configure the AWS provider and region
provider "aws" {
  region = "us-east-1"  # Change if needed
}

# Create a globally unique S3 bucket
resource "aws_s3_bucket" "static_site_bucket" {
  bucket        = "heyapurv-static-site-20250813" # Change this to a globally unique name
  force_destroy = true

  tags = {
    Name        = "StaticWebsiteBucket"
    Environment = "production"
  }
}

# Disable public access block so policy can be applied
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket                  = aws_s3_bucket.static_site_bucket.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}

# Enable static website hosting
resource "aws_s3_bucket_website_configuration" "static_site_config" {
  bucket = aws_s3_bucket.static_site_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# Make bucket content publicly readable
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket     = aws_s3_bucket.static_site_bucket.id
  depends_on = [aws_s3_bucket_public_access_block.public_access_block]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site_bucket.arn}/*"
      }
    ]
  })
}

# Output the website endpoint
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_site_config.website_endpoint
}
