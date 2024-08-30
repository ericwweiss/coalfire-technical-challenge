
output "ec2instance_ip" {
  value = aws_instance.redhat_instance.public_ip
}