variable "vpc_id" {
    type        = string
    description = "Main VPC ID"
}

variable "security_group_id" {
    type        = string
    description = "VPC SG ID"
}

variable "key_name" {
    type        = string
    description = "Amazon provided Key Name"
}

variable "public_subnet_id_list" {
  type        = list
  description = "List of Public Subnets"
}

variable "private_subnet_id_list"  {
  type        = list
  description = "List of Private Subnets"
}

variable "region" {
    default     = "us-east-2"
    type        = string
    description = "AWS Region"
}

variable "availability_zone" {
  type        = string
  default     = "us-east-2b"
  description = "Desired Avaliability Zones"
}

variable "instance_ami" {
    type        = string
    default     = "ami-0aa8fc2422063977a" # Redhat 9 64-bit x86 AMI id
    description = "ami"

}

variable "ebs_storage" {
    type        = string
    default     = 20
    description = "Size in GB"

}

variable "instance_type" {
    type        = string
    default     = "t2.micro"
    description = "Target Instance Type"

}

variable "environment" {
    default     = "Coalfire"
    type        = string
    description = "Environment to Deploy to"
}

variable "script_public" {
    default = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    sudo insights-client --register
    EOF
}

variable "script_private" {
    default = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    sudo systemctl enable amazon-ssm-agent
    sudo systemctl start amazon-ssm-agent
    sudo yum install -y httpd.x86_64
    systemctl start httpd.service
    systemctl enable httpd.service
    echo “Hello Coalfire from $(hostname -f)” > /var/www/html/index.html
    sudo insights-client --register
    EOF
}
