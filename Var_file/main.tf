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

variable "jsonvalues" {
    type = map(string)
    description = "this will provide values to role attributes"
}

resource "aws_iam_role" "s3_bucket_role" {
  name = "s3_bucket_role"
  assume_role_policy = templatefile("../Templating/Assume_Role_template.tftpl", var.jsonvalues)
}

#while running terraform apply use below command
#terraform apply -var-file="jasonvalues.tfvars"