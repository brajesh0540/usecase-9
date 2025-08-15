terraform {
required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "5.82.2"
    }
}
}

provider "aws" {
region = var.region
}

terraform {
  backend "s3" {
    bucket = "my-terraform-state-brajesh1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}

