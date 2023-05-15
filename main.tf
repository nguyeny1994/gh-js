terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.44.0"
    }
  }
}

provider "aws" {
#     access_key = ""
#     secret_key = ""
      	region = "us-east-1"
}

resource "aws_s3_bucket" "static" {
  bucket        = "gh-js"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "static" {
    bucket = aws_s3_bucket.static.bucket
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "static" {
    bucket = aws_s3_bucket.static.bucket
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "static" {
    depends_on = [
        aws_s3_bucket_public_access_block.static,
        aws_s3_bucket_ownership_controls.static,
    ]

    bucket = aws_s3_bucket.static.bucket
    acl = "public-read"
}

resource "aws_s3_bucket_policy" "static_policy" {
    bucket = aws_s3_bucket.static.bucket
#     policy = data.aws_iam_policy_document.static_policy.json
    policy = file("s3_static_policy.json")
}
resource "aws_s3_bucket_website_configuration" "static" {
  bucket = aws_s3_bucket.static.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
# resource "aws_s3_bucket_public_access_block" "static" {
#   bucket = aws_s3_bucket.static.id

#   block_public_acls       = false
#   block_public_policy     = false
# }

# resource "aws_s3_bucket_policy" "static" {
#   bucket = aws_s3_bucket.static.id
#   policy = file("s3_static_policy.json")
# }
