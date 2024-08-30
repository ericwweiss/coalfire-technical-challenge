output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id_list" {
  value = aws_subnet.public_subnets.*.id
}

output "private_subnet_id_list" {
  value = aws_subnet.private_subnets.*.id
}

output "security_group_id" {
  value = aws_security_group.main_default.id
}