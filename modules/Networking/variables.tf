
variable "vpc_cidr" {
    type        = string
    description = "Main VPC CIDR"
}

variable "region" {
    default     = "us-east-2"
    type        = string
    description = "AWS Region"
}

variable "azs" {
  type        = list
  default     = ["us-east-2a" , "us-east-2b"]
  description = "Desired Avaliability Zones"
}

variable "public_subnets" {
  type        = list
  default     = ["10.1.0.0/24" , "10.1.1.0/24"]
  description = "Public Subnets"
}

variable "private_subnets" {
  type        = list
  default     = ["10.1.2.0/24" , "10.1.3.0/24"]
  description = "Private Subnets"
}


variable "environment" {
    default     = "Coalfire"
    type        = string
    description = "Environment to Deploy to"
}