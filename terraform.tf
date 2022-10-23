terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  cloud {
    organization = "terraform-luis"

    workspaces {
      name = "challenge-terraform"
    }
  }
}