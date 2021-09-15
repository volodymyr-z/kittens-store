output "security_group_ids" {
  value = aws_security_group.SECURITY_GROUP_PORTS.id
}

output "your_ip" {
  value = chomp(data.http.myip.body)
}

output "security_group" {
  value = aws_security_group.SECURITY_GROUP_PORTS
}
