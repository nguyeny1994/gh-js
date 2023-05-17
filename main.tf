terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.44.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "static" {
  bucket        = "gh-js"
  force_destroy = true
#   acl = "public-read"
  provisioner "local-exec" {
    command = "sleep 10"
  }
}
# resource "aws_s3_bucket_public_access_block" "static" {
#   bucket = aws_s3_bucket.static.id

#   block_public_acls       = false
#   block_public_policy     = false
#   provisioner "local-exec" {
#     command = "sleep 10"
#   }
# }

resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id
  policy = file("s3_static_policy.json")
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_s3_bucket_ownership_controls" "static" {
  bucket = aws_s3_bucket.static.id

  rule {
    object_ownership = "ObjectWriter"
#     acls_disabled = true
  }
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# resource "aws_s3_bucket_acl" "static" {
#   depends_on = [aws_s3_bucket_ownership_controls.static]

#   bucket = aws_s3_bucket.static.id
#   acl    = "public-read"
# }

resource "aws_s3_bucket_website_configuration" "static" {
  bucket = aws_s3_bucket.static.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# resource "aws_s3_bucket_acl" "static" {
#   bucket = aws_s3_bucket.static.id
#   acl    = "public-read"
# }




