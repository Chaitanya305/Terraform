terraform {
    required_providers {
      aws = {
        version = "5.57.0"
        source = "hashicorp/aws"
      }
    }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "s3_bucket_role" {
  name = "s3_bucket_role"
  assume_role_policy = templatefile("./Assume_Role_template.tftpl", {effect: "Allow", Sid: "AssumeRoleFors3", Service: "s3.amazonaws.com"})
}