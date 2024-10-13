variable "vpc_cidr" {
	type = string
	description = "this is varibale for vpc cidr "
}

variable "vpc_name" {
	type = string
	description = "this is name of vpc"
}

variable "private_sub_cidr" {
	type = string
	description = "this is cidr for private subnate"
}

variable "private_sub_az" {
	type = string
	description = "this is az for private subnet"
}

variable "private_sub_name" {
	type = string
	description = "this is name for private subnate"
}

variable "public_sub_name" {
	type = string
	description = "this is public sub name"
}

variable "public_sub_az" {
	type = string
	description = "this is pub sub az"
}

variable "public_sub_cidr" {
	type = string
	description = "this is cidr for public subnet"
}

variable "igw_name" {
	type = string
	description = "this is igw name"
}

variable "rtable_name" {
	type = string
	description = "this is public rtable name"
}

variable "key_name" {
	type = string
	description = "this is name of key which will attach to your instances"
}

variable "pub_key_path" {
	type = string
	description = "this is pub_key path description"
}

variable "pub_ami" {
	type = string
	description = "this is ami for public instnace"
}

variable "priv_ami" {
	type = string
	description = "this is private instnace ami"
}

variable "pub_instance_type" {
	type = string
	description = "this is public instnace type"
}

variable "priv_instance_type" {
	type = string
	description = "this is private instnace type"
}

variable "pub_instance_name" {
	type = string
	description = "this is public instnace name"
}

variable "priv_instance_name" {
	type = string
	description = "this is private instnace name"
}
