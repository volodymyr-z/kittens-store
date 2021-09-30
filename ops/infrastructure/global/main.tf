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

data "aws_availability_zones" "zones" {
  state = "available"
}

resource "aws_security_group" "security_office_1" {
  name_prefix = "office"
  description = "Connect RDS and Instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "RDS Port"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "office"
  }
}

module "vpc" {
  source = "../modules/aws-vpc"

  cidr_block = "10.0.0.0/16"
  availability_zones = data.aws_availability_zones.zones.names
}

module "security" {
  source = "../modules/aws-security-group"
  vpc_id = module.vpc.vpc_id
}

module "rds" {
  source = "../modules/aws-rds-instance"

  name = "NewDatabase"
  vpc = module.vpc
  assigned_security_groups = [aws_security_group.security_office_1.id]
}

module "app_instance" {
  source = "../modules/aws-app-instance"

  subnet_id = module.vpc.subnet_ids[0]
  security_group_ids = module.security.security_group_ids
  assigned_security_groups = [aws_security_group.security_office_1.id]
  instance_count = 2
}

module "load_balancer" {
  source = "../modules/aws-load-balancer"
  vpc = module.vpc
  instance_ids = module.app_instance.instance_ids
  security_group_ids = [module.security.security_group_ids]
}
