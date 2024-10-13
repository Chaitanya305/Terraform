terraform{
    required_providers {
      aws =  {
            source = "hashicorp/aws"
            version = "5.38.0"
        }
    }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "demo-user" {
    name = "demo-user"
    path = "/"
}

resource "aws_iam_user_login_profile" "demo-user" {
  user = aws_iam_user.demo-user.name
  pgp_key = file("C:/Users/Shree/Downloads/publicbase64.key")
  password_reset_required = true
}

resource "aws_iam_access_key" "demo-user" {
  user = aws_iam_user.demo-user.name
  pgp_key = file("C:/Users/Shree/Downloads/publicbase64.key")
}

output "secret_value" {
  value = aws_iam_access_key.demo-user.encrypted_secret
  description = "this is secret key for the user"
}

output "acces_id" {
  value = aws_iam_access_key.demo-user.id
}

output "user_onetime_pass" {
  value = aws_iam_user_login_profile.demo-user.encrypted_password
  description = "this is pass for console login"
}
