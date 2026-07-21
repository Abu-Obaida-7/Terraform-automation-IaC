terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
  bucket = "obaida-terraform-state-bucket-2026"
  key    = "terraform.tfstate"
  region = "us-east-1"
  dynamodb_table = "state-bucket" #use this table for state locking
  

  }


}

