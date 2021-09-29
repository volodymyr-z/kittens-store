output "vpc_id" {
  value = aws_vpc.VPC.id
}

output "subnet_ids" {
  value = [for subnets in aws_subnet.subnet : subnets.id]
}

output "location" {
  value = var.location
}

output "availability_zones" {
  value = [for subnets in aws_subnet.subnet : subnets.availability_zone]
}
