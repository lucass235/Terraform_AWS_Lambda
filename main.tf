terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "lucas_test_gato_bucket" {
  bucket = "lucas-s3-test-bucket"
}


