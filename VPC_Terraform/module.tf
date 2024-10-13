terraform {
	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = "5.31.0"
		}
	}
}

provider "aws" {
	region = "us-east-1"
}

module "vpc" {
	source = "./module"
	vpc_cidr = "10.0.0.0/24"
	vpc_name = "demo_vpc"
	private_sub_cidr = "10.0.0.0/25"
	private_sub_az = "us-east-1a"
	private_sub_name = "private_subnet"
	public_sub_name = "public_subnet"
	public_sub_cidr = "10.0.0.128/25"	
	public_sub_az = "us-east-1b"
	igw_name = "demo_igw"
	rtable_name = "public_rtable"
	key_name = "demo_key"
	pub_key_path = "/home/chaitanya/.ssh/id_rsa.pub"
	pub_ami = "ami-0c7217cdde317cfec"
	priv_ami = "ami-0c7217cdde317cfec"
	pub_instance_type = "t2.micro"
	priv_instance_type = "t2.micro"
	priv_instance_name = "private_instnace"
	pub_instance_name = "public_instance"
}

output "mod_pub_instance_pub_ip" {
	value = module.vpc.pub_instance_pub_ip
}

output "mod_pub_instance_priv_ip" {
	value = module.vpc.pub_instance_priv_ip
}

output "mod_priv_instance_priv_ip" {
	value = module.vpc.priv_instance_priv_ip
}
