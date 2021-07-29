resource "aws_vpc" "VPC" {
  cidr_block = var.cidr_block
  tags = {
    Name = "VPC"
  }
}

resource "aws_internet_gateway" "GW" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "AWS GW"
  }
}

resource "aws_route_table" "ROUTING_TABLE" {
  count = length(aws_subnet.SUBNET)

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

  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  vpc_id = aws_vpc.VPC.id
  cidr_block =  cidrsubnet(var.cidr_block,8,count.index + 1)

  tags = {
    Name = "Subnet-public-${count.index + 1}"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
