terraform {
  required_version = ">= 1.8.0"

  backend "s3" {
    bucket       = "artur-marbach-vikunja-terraform-state"
    key          = "vikunja-fargate/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}