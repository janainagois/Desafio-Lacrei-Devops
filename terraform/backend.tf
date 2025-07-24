terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "bucket-statefile-lacrei"
    key            = "terraform/state/infra.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }
}