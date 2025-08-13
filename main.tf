# main.tf

# Configure the AWS provider and region
provider "aws" {
  region = "us-east-1"  # You can change this to your desired AWS region
}

# Create a globally unique S3 bucket
resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "your-unique-website-bucket-name" # Change this to a globally unique name

  tags = {
    Name        = "StaticWebsiteBucket"
    Environment = "production"
  }
}

# Enable static website hosting on the bucket
resource "aws_s3_bucket_website_configuration" "static_site_config" {
  bucket = aws_s3_bucket.static_site_bucket.id

  index_document {
    suffix = "index.html"
  }

}

# Make the bucket content publicly readable
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.static_site_bucket.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_site_bucket.arn}/*"
      }
    ]
  })
}

# Output the website endpoint URL after deployment
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.static_site_config.website_endpoint
}