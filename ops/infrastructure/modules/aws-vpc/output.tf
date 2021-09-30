output "vpc_id" {
  value = aws_vpc.default_vpc.id
}

output "subnet_ids" {
  value = [for x in aws_subnet.subnet : x.id]
}

output "location" {
  value = var.location
}

output "availability_zones" {
  value = [for x in aws_subnet.subnet : x.availability_zone]
}
