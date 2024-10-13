resource "aws_vpc" "vpc_rs" {
	cidr_block = var.vpc_cidr
	tags = {
		Name = var.vpc_name
	}
}

resource "aws_subnet" "private_subnet_rs" {
	vpc_id = aws_vpc.vpc_rs.id
	cidr_block = var.private_sub_cidr
	availability_zone = var.private_sub_az
	tags = {
		Name = var.private_sub_name
	}
	depends_on = [ aws_vpc.vpc_rs ]
}

resource "aws_subnet" "public_subnet_rs" {
	vpc_id = aws_vpc.vpc_rs.id
	cidr_block = var.public_sub_cidr
	availability_zone = var.public_sub_az
	tags = {
		Name = var.public_sub_name
	}
	map_public_ip_on_launch = "true"
	depends_on = [ aws_vpc.vpc_rs ]
}

resource "aws_internet_gateway" "igw_rs" {
	vpc_id = aws_vpc.vpc_rs.id
	tags = {
		Name = var.igw_name
	}
	depends_on = [ aws_vpc.vpc_rs ]
}

resource "aws_route_table" "rtable_rs" {
	vpc_id = aws_vpc.vpc_rs.id
	tags = {
		Name = var.rtable_name
	}	
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw_rs.id
	}
	depends_on = [ aws_vpc.vpc_rs ]
}

resource "aws_route_table_association" "tbale_associate_rs" {
	subnet_id = aws_subnet.public_subnet_rs.id
	route_table_id = aws_route_table.rtable_rs.id
	depends_on = [ aws_subnet.public_subnet_rs ]
}

resource "aws_key_pair" "key_rs" {
	key_name = var.key_name
	public_key = file(var.pub_key_path)
}

resource "aws_security_group" "sg_rs" {
	vpc_id = aws_vpc.vpc_rs.id
	name = "ssh_icmp_sg"
	description = "allow ssh and allow to ping each others in vpc"
	
	ingress {
		description = "allow ssh"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	
	ingress {
		description = "alllow ICMP"
		from_port = -1 
		to_port = -1
		protocol = "icmp"
		cidr_blocks = [ aws_vpc.vpc_rs.cidr_block ]
	}
	
	egress {
		description = "allow all outbound traffic"
		from_port = 0
		to_port = 0 
		protocol = -1 
		cidr_blocks = ["0.0.0.0/0"]
	}
	depends_on = [ aws_vpc.vpc_rs ]
}

resource "aws_instance" "public_instance_rs" {
	ami = var.pub_ami
	instance_type = var.pub_instance_type
	key_name = aws_key_pair.key_rs.key_name
	tags = {
		Name = var.pub_instance_name
	}
	subnet_id = aws_subnet.public_subnet_rs.id
	security_groups = [ aws_security_group.sg_rs.id ]
	depends_on = [ aws_subnet.public_subnet_rs, aws_security_group.sg_rs, aws_key_pair.key_rs ]
}

resource "aws_instance" "private_instance_rs" {
	ami = var.priv_ami
	instance_type = var.priv_instance_type
	key_name = aws_key_pair.key_rs.key_name
	subnet_id = aws_subnet.private_subnet_rs.id
	tags = {
		Name = var.priv_instance_name
	}
	security_groups = [ aws_security_group.sg_rs.id ]
	depends_on = [ aws_subnet.private_subnet_rs, aws_security_group.sg_rs, aws_key_pair.key_rs ]
}
