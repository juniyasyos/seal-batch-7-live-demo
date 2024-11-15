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

  # backend "s3" {
  #   bucket         = "seal-remote-state-copy-duty"
  #   key            = "state"
  #   region         = "us-east-1"
  #   dynamodb_table = "SealRemoteState"
  # }

  required_version = ">= 1.9.8"
}
