output "vpc_id" {
  value = aws_vpc.VPC.id
}

output "subnet_ids" {
  value = aws_subnet.SUBNET.*.id
}

output "location" {
  value = var.location
}

output "availability_zones" {
  value = aws_subnet.SUBNET[*].availability_zone
}
