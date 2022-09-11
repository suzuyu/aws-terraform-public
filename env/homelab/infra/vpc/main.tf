terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=4.30.0"
    }
  }
  # https://www.terraform.io/language/settings/backends/s3
  backend "s3" {
    bucket  = "tfstate-bucketXXXXX" # terraform の backend にする S3 バケット (../README.md で作成したもの)
    key     = "infra/vpc/terraform.state"
    region  = "ap-northeast-1"
    profile = "infra"
    # shared_credentials_file = "~/.aws/credentials" # default path
    # encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "ap-northeast-1"
  profile = "infra"
  # shared_credentials_file = "~/.aws/credentials" # default path
}
