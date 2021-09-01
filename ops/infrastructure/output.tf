output "vpc_id" {
  value = aws_vpc.VPC.id
}

output "subnet_ids" {
  value = [aws_subnet.SUBNET.*.id]
}

output "availability_zones" {
  value = aws_subnet.SUBNET[*].availability_zone
}

output "your_ip" {
  value = chomp(data.http.myip.body)
}

output "public_ip" {
  value = aws_instance.INSTANCE_NEW.public_ip
}
