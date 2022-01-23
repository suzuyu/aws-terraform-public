terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=3.73.0"
    }
  }
  # https://www.terraform.io/language/settings/backends/s3
  backend "s3" {
    bucket = "tfstate-bucketXXXXX" # AWS 全体で重複しない名称をアサイン ($ echo tfstate-bucket$RANDOM などで生成)
    key    = "homelab-organizations"
    region = "ap-northeast-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
}
