variable "bucket_name" {
    default     = "coalfire-media-kf-tech" 
    type        = string
    description = "Bucket Name"
}

variable "acl" {
    default     = "private"
    type        = string
    description = "acl"
}

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