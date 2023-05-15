terraform {
  required_version = ">= 1.0.11"
}
variable "env" {
  description = "The name of the environment we are deploying to"
  type        = string
  default     = "test"
}
provider "aws" {
#   access_key = ""
#   secret_key = ""
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
  acl           = "null"

  # Allow deletion of non-empty bucket
  force_destroy = true
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  # attach_elb_log_delivery_policy = true # Required for ALB logs
  # attach_lb_log_delivery_policy  = true # Required for ALB/NLB logs
#   attach_public_policy = true
  # block_public_policy = false
  # force_destroy = true
  attach_policy = true
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": [
                "arn:aws:s3:::gh-js/*"
            ],
            "Effect": "Allow"
        }
    ]
}
EOF
website = {
    index_document = "index.html"
    error_document = "error.html"
  }
}
