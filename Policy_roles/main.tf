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

resource "aws_iam_role" "ec2-demo-role" {
    name = "ec2-demo-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = "AssumeRoleForEC2"
            Principal = {
            Service = "ec2.amazonaws.com"
            }
        },
        ]
    })
}

resource "aws_iam_policy" "ec2-stop-start-policy" {
    name = "ec2-stop-start-policy"
    policy = jsonencode({
        Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Create", "ec2:Stop", "ec2:Delete"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
    })
}

resource "aws_iam_policy_attachment" "test-attach" {
    name = "ec2-policy-attach"
    policy_arn = aws_iam_policy.ec2-stop-start-policy.arn
    roles = [aws_iam_role.ec2-demo-role.name]
    depends_on = [ aws_iam_policy.ec2-stop-start-policy, aws_iam_role.ec2-demo-role ]
}