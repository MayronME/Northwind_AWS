terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configuração do AWS Provider
provider "aws" {
  region = var.region_aws
}
