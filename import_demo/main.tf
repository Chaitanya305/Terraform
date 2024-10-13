terraform {
    required_providers {
      aws = {
         source = "hashicorp/aws"
         version = "5.38.0"
      }
    }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-instance" {
  instance_type = "t2.micro"
  ami = "ami-066784287e358dad1"
  tags = {
    Name = "demo-svc"
  }
}


#   resource "aws_instance" "demo-instance" {
#     #
#   }

# to Perform import you should have atleas resource block define in your confiug file later on you can add the configuration of that resource in config file, untill state file and config file is same.