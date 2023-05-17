terraform {
  required_version = ">= 1.0.11"
}
variable "env" {
  description = "The name of the environment we are deploying to"
  type        = string
  default     = "test"
}
provider "aws" {
    region = "us-east-1"
}
module "s3_bucket" {
    source  = "terraform-aws-modules/s3-bucket/aws"
    version = "3.8.2"

    bucket = "gh-js"
    # acl    = "public-read"

    # Allow deletion of non-empty bucket
    # force_destroy = true

    
    block_public_policy = false
    block_public_acls = false
    ignore_public_acls = false
    restrict_public_buckets = false
    attach_elb_log_delivery_policy = true # Required for ALB logs
    attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs
    control_object_ownership = true
    object_ownership         = "ObjectWriter"
    # attach_policy = true
    # policy = <<EOF
    # {
    #     "Version": "2012-10-17",
    #     "Statement": [
    #         {
    #             "Principal": "*",
    #             "Action": "s3:GetObject",
    #             "Resource": [
    #                 "arn:aws:s3:::gh-js/*"
    #             ],
    #             "Effect": "Allow"
    #         }
    #     ]
    # }
    # EOF
    website = {
        index_document = "index.html"
        error_document = "error.html"
    }
}

resource "aws_s3_bucket_policy" "read_access" {
    bucket = module.s3_bucket.s3_bucket_id
    policy = file("s3_static_policy.json")
    depends_on = [module.s3_bucket]
    provisioner "local-exec" {
      command = "sleep 30"
#     interpreter = ["PowerShell", "-Command"]
#     command = "start-sleep 50"
  }
#   depends_on = [
#     time_sleep.wait_2_seconds
#   ]
}












# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "4.44.0"
#     }
#   }
# }

# provider "aws" {
#     region = "us-east-1"
# }

# resource "aws_s3_bucket" "static" {
#   bucket        = "gh-js"
#   force_destroy = true
# #   acl = "public-read"
#   provisioner "local-exec" {
#     command = "sleep 10"
#   }
# }
# # resource "aws_s3_bucket_public_access_block" "static" {
# #   bucket = aws_s3_bucket.static.id

# #   block_public_acls       = false
# #   block_public_policy     = false
# #   provisioner "local-exec" {
# #     command = "sleep 10"
# #   }
# # }

# resource "aws_s3_bucket_policy" "static" {
#   bucket = aws_s3_bucket.static.id
#   policy = file("s3_static_policy.json")
#   provisioner "local-exec" {
#     command = "sleep 10"
#   }
# }

# resource "aws_s3_bucket_ownership_controls" "static" {
#   bucket = aws_s3_bucket.static.id

#   rule {
#     object_ownership = "ObjectWriter"
# #     acls_disabled = true
#   }
#   provisioner "local-exec" {
#     command = "sleep 10"
#   }
# }

# # resource "aws_s3_bucket_acl" "static" {
# #   depends_on = [aws_s3_bucket_ownership_controls.static]

# #   bucket = aws_s3_bucket.static.id
# #   acl    = "public-read"
# # }

# resource "aws_s3_bucket_website_configuration" "static" {
#   bucket = aws_s3_bucket.static.bucket

#   index_document {
#     suffix = "index.html"
#   }

#   error_document {
#     key = "error.html"
#   }
#   provisioner "local-exec" {
#     command = "sleep 10"
#   }
# }

# # resource "aws_s3_bucket_acl" "static" {
# #   bucket = aws_s3_bucket.static.id
# #   acl    = "public-read"
# # }




