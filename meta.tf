terraform {
  required_version = ">= 1.0.0"
  backend "s3" {
    bucket = "pathways-dojo"
    key    = "tkav-tfstate-main"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "aws"
      version = "~> 3.30.0"
    }
  }

}