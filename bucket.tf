
terraform {
  backend "s3" {
    bucket = "my-terraform-state-brajesh1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "my_state_bucket" {
    bucket = "my-terraform-state-brajesh1"
    object_lock_enabled = true
    
  }


resource "aws_s3_bucket_versioning" "versioning_bucket" {
  bucket = aws_s3_bucket.my_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}