# provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66.1"
    }
  }

  required_version = ">= 1.5.5"
}

# Define the AWS provider block to specify the AWS region.
provider "aws" {
  region = "us-east-1"
  # Authentication requires the following environment variables:
  #     AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_SESSION_TOKEN
}