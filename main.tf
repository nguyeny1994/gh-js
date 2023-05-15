# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "4.64.0"
#     }
#   }
# }

# # provider "aws" {
# # #     access_key = ""
# # #     secret_key = ""
# #       	region = "us-east-1"
# # }

# # # resource "aws_s3_bucket" "static" {
# # #   bucket        = "gh-js"
# # #   force_destroy = true
# # # }
# # module "s3_bucket" {
# #   source = "terraform-aws-modules/s3-bucket/aws"

# #   bucket = "gh-js"
# #   acl    = "private"

# #   control_object_ownership = true
# #   object_ownership         = "ObjectWriter"

# #   versioning = {
# #     enabled = true
# #   }
# # }
# # # resource "aws_s3_bucket_public_access_block" "static" {
# # #     bucket = aws_s3_bucket.static.bucket
# # #     block_public_acls = false
# # #     block_public_policy = false
# # #     ignore_public_acls = false
# # #     restrict_public_buckets = false
# # # }

# # # resource "aws_s3_bucket_ownership_controls" "static" {
# # #     bucket = aws_s3_bucket.static.bucket
# # #     rule {
# # #         object_ownership = "BucketOwnerPreferred"
# # #     }
# # # }
# # # resource "aws_s3_bucket_website_configuration" "static" {
# # #   bucket = aws_s3_bucket.static.bucket

# # #   index_document {
# # #     suffix = "index.html"
# # #   }

# # #   error_document {
# # #     key = "error.html"
# # #   }
# # # }

# # # resource "aws_s3_bucket_policy" "static" {
# # #   bucket = aws_s3_bucket.static.id
# # #   policy = file("s3_static_policy.json")
# # # }


# module "s3_bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "3.8.2"

#   bucket        = "gh-js"

#   force_destroy = true

#   website = {
#     index_document = "index.html"
#     error_document = "error.html"
#   }

# }

# data "aws_iam_policy_document" "read_access" {
#   statement {
#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }
#     actions   = ["s3:GetObject"]
#     resources = ["${module.s3_bucket.s3_bucket_arn}/*"]
#   }
# }

# # Need for avoid `Error putting S3 policy: AccessDenied: Access Denied`
# resource "time_sleep" "wait_2_seconds" {
#   depends_on      = [module.s3_bucket.s3_bucket_website_domain]
#   create_duration = "2s"
# }

# resource "aws_s3_bucket_policy" "read_access" {
#   bucket = module.s3_bucket.s3_bucket_id
#   policy = data.aws_iam_policy_document.read_access.json

#   depends_on = [
#     time_sleep.wait_2_seconds
#   ]
# }

terraform {
  required_version = ">= 1.0.11"
}
variable "env" {
  description = "The name of the environment we are deploying to"
  type        = string
  default     = "test"
}
provider "aws" {
  access_key = "AKIA3UNIP7FP66UYIFDW"
  secret_key = "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"
  region = "us-east-1"
  default_tags {
    tags = {
      ManagedByTerraform = true
    }
  }
}
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = "gh-js"
  acl           = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  attach_elb_log_delivery_policy = true # Required for ALB logs
  attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  # force_destroy = true

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

}
