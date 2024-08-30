variable "region" {
    default     = "us-east-2"
    type        = string
    description = "AWS Region"
}

variable "environment" {
    default     = "Coalfire"
    type        = string
    description = "Environment to Deploy to"
}