provider "aws" {
  region = module.vpc.location
}

terraform {
  backend "s3" {
    bucket = "terraform-state-711454914059"
    region = "us-west-2"
    key    = "global/terraform.tfstate"
  }
}

module "vpc" {
  source = "../modules/aws-vpc"

  cidr_block = "10.0.0.0/16"
  subnets_number = 2
}

module "security" {
  source = "../modules/aws-security-group"
  vpc_id = module.vpc.vpc_id
}

module "app_instance" {
  source = "../modules/aws-app-instance"

  subnet_id = module.vpc.subnet_ids[0]
  security_group_ids = module.security.security_group_ids
}