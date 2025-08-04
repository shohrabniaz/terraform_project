# Terraform Settings Block
/*terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}


# Provider Block
provider "aws" {
  region  = "us-west-1"
  profile = "default"
}*/
## Terraform Settings Block
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16.1"
    }
  }
}


# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}
