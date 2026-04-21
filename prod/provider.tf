terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.15.0"
    }
  }
  required_version = ">= 0.14.0"

  # Remote state — create this S3 bucket and DynamoDB table before running terraform init:
  #   aws s3api create-bucket --bucket amplify-terraform-state-135808927724 --region us-east-1
  #   aws s3api put-bucket-versioning --bucket amplify-terraform-state-135808927724 --versioning-configuration Status=Enabled
  #   aws dynamodb create-table --table-name amplify-terraform-locks --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region us-east-1
  backend "s3" {
    bucket         = "amplify-terraform-state-135808927724"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "amplify-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
  ignore_tags {
  keys = ["*"]
  }
}
