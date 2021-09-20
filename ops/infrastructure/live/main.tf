terraform {
  backend "s3" {
    bucket = "terraform-state-711454914059"
    region = "us-west-2"
    key    = "live/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-west-2"
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket  = "terraform-state-711454914059"
    key     = "global/terraform.tfstate"
    region  = "us-west-2"
  }
}

locals {
  global_config = {
    vpc_id = data.terraform_remote_state.global.outputs.vpc_id
  }
}
