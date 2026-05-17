terraform {
  backend "s3" {
    bucket         = "nt548-terraform-state-bucket-23520552" # Change this to your unique bucket name
    key            = "lab1/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nt548-terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
