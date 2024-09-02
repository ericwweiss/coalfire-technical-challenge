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

resource "aws_s3_bucket" "images_bucket" {
  bucket = var.bucket_name_1
  acl    = var.acl
  
  lifecycle_rule {
    id      = "glacier-images"
    enabled = true
    prefix  = "Memes/"
    transition {
      days          = 90
      storage_class = "GLACIER"
      }
    }

    tags = {
        Name = var.bucket_name_1
        Environment = var.environment
    }
}

resource "aws_s3_bucket" "logs_bucket" {
  bucket = var.bucket_name_2
  acl    = var.acl
  
  lifecycle_rule {
    id      = "glacier-logs"
    enabled = true
    prefix  = "Active/"
    transition {
      days          = 90
      storage_class = "GLACIER"
      }
    }
    
  lifecycle_rule {
    id      = "logs"
    enabled = "true"
    prefix  = "Inactive/"
    expiration {
      days  = 90
      }
    }

    tags = {
        Name = var.bucket_name_2
        Environment = var.environment
    }
}

#-------------Images & Logs Folders-----------------------

resource "aws_s3_object" "Archive" {
  bucket       = "${aws_s3_bucket.images_bucket.id}"
  key          = "Memes/"
  content_type = "application/x-directory"
}

resource "aws_s3_object" "Memes" {
  bucket       = "${aws_s3_bucket.images_bucket.id}"
  key          = "Memes/"
  content_type = "application/x-directory"
}

resource "aws_s3_object" "Active" {
  bucket       = "${aws_s3_bucket.logs_bucket.id}"
  key          = "Active/"
  content_type = "application/x-directory"
}

resource "aws_s3_object" "Inactive" {
  bucket       = "${aws_s3_bucket.logs_bucket.id}"
  key          = "Inactive/"
  content_type = "application/x-directory"
}
