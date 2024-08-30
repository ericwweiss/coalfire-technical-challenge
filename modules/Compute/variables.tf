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
    default     = "ami-0ba62214afa52bec7" #Redhat
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