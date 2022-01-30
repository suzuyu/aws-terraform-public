terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=3.73.0"
    }
  }
  # https://www.terraform.io/language/settings/backends/s3
  backend "s3" {
    bucket = "tfstate-bucketXXXXX" # terraform の backend にする S3 バケット (../organizaions/main.tf と同じでよい)
    key    = "homelab-sso"
    region = "ap-northeast-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
}
