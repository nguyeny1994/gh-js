terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.44.0"
    }
  }
}

provider "aws" {
    	access_key = "AKIAROVXYRQLXACTLAG4"
	secret_key = "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"
    	region = "us-east-1"
}

resource "aws_s3_bucket" "static" {
  bucket        = "gh-js"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "static" {
  bucket = aws_s3_bucket.static.id
  acl    = "public-read"
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


resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id
  policy = file("s3_static_policy.json")
}
