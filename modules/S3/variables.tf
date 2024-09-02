variable "bucket_name_1" {
    default     = "coalfire-images-eric-weiss" 
    type        = string
    description = "Bucket Name"
}

variable "bucket_name_2" {
    default     = "coalfire-logs-eric-weiss" 
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
    description = "poc"
}
