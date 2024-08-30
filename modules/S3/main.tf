terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65.0"
    }
  }

  required_version = ">= 1.9.5"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

#-------------S3 Bucket-----------------------

resource "aws_s3_bucket" "coalfire-bucket" {
  bucket = var.bucket_name
  acl    = var.acl
  
  lifecycle_rule {
    id      = "images"
    enabled = true
    prefix  = "images/"
    transition {
      days          = 90
      storage_class = "GLACIER"
      }
    }
    
  lifecycle_rule {
    id      = "logs"
    enabled = "true"
    prefix  = "logs/"
    expiration {
      days  = 90
      }
    }

    tags = {
        Name = var.bucket_name
        Environment = var.environment
    }
}

#-------------Image & Log Folders-----------------------

resource "aws_s3_bucket_object" "coalfire-bucket-images" {
  bucket = "${aws_s3_bucket.coalfire-bucket.id}"
  acl    = "private"
  key    = "images/"
}

resource "aws_s3_bucket_object" "coalfire-bucket-logs" {
  bucket = "${aws_s3_bucket.coalfire-bucket.id}"
  acl    = "private"
  key    = "logs/"
}