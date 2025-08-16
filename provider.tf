terraform {
required_providers {
    aws = {
    source = "hashicorp/aws"
    version = "5.82.2"
        }
    }
}

#terraform {
#  backend "s3" {
#    bucket = "my-terraform-state-brajesh1"
#    key    = "eks/terraform.tfstate"
#    region = "us-east-1"
#  }
#}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test" # dummy for LocalStack
  secret_key                  = "test" # dummy for LocalStack
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  s3_use_path_style = true

endpoints {
    ec2            = "http://aws:4566"
    apigateway     = "http://aws:4566"
    cloudformation = "http://aws:4566"
    cloudwatch     = "http://aws:4566"
    dynamodb       = "http://aws:4566"
    es             = "http://aws:4566"
    firehose       = "http://aws:4566"
    iam            = "http://aws:4566"
    kinesis        = "http://aws:4566"
    lambda         = "http://aws:4566"
    route53        = "http://aws:4566"
    redshift       = "http://aws:4566"
    s3             = "http://aws:4566"
    secretsmanager = "http://aws:4566"
    ses            = "http://aws:4566"
    sns            = "http://aws:4566"
    sqs            = "http://aws:4566"
    ssm            = "http://aws:4566"
    stepfunctions  = "http://aws:4566"
    sts            = "http://aws:4566"
    rds            = "http://aws:4566"
    eks            = "http://aws:4566"
  }
}
