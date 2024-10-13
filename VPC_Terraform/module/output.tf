output "pub_instance_pub_ip"{
	value = aws_instance.public_instance_rs.public_ip
}

output "pub_instance_priv_ip"{
	value = aws_instance.public_instance_rs.private_ip
}

output "priv_instance_priv_ip" {
	value = aws_instance.private_instance_rs.private_ip
}
