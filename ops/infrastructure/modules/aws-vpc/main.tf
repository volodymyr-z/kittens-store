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

resource "aws_vpc" "VPC" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.project_name
  }
}

resource "aws_internet_gateway" "GW" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "AWS GW"
  }
}

resource "aws_route_table" "ROUTING_TABLE" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = var.routing_table_cidr
    gateway_id = aws_internet_gateway.GW.id
  }

  tags = {
    Name = "RoutingTable-public"
  }
}

resource "aws_subnet" "SUBNET" {
  count = 2

  availability_zone = element(data.aws_availability_zones.zones.names, count.index)
  vpc_id            = aws_vpc.VPC.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 1)

  tags = {
    Name = "Subnet-public-${count.index + 1}"
  }
}

data "aws_availability_zones" "zones" {
  state = "available"
}

resource "aws_route_table_association" "ROUTE_TABLE" {
  count = 2

  subnet_id      = element(aws_subnet.SUBNET[*].id, count.index)
  route_table_id = aws_route_table.ROUTING_TABLE.id
}
