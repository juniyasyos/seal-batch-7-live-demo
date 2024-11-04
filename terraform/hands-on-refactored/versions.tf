terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
  required_version = ">= 1.9.8"

  backend "s3" {
    bucket         = "tfremotestate-ec2"
    key            = "state"
    region         = "eu-central-1"
    dynamodb_table = "tfremotestate-ec2"
  }
}
