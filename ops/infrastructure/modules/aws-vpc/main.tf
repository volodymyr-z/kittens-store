terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.location
}

locals {
  availability_zones = sort(var.availability_zones)
}

resource "aws_vpc" "VPC" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.project_name
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_route_table" "routing_table" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = var.routing_table_cidr
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "RoutingTable-public"
  }
}

resource "aws_subnet" "subnet" {
  for_each = toset(local.availability_zones)

  availability_zone = each.key
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, index(local.availability_zones, each.key) + 1)

  tags = {
    Name = "Subnet-public-${index(local.availability_zones, each.key)}"
  }
}

resource "aws_route_table_association" "route_table" {
  for_each = aws_subnet.subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.routing_table.id
}
