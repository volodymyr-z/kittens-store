output "host" {
  value = aws_db_instance.main.address
}

output "database" {
  value = aws_db_instance.main.name
}

output "user" {
  value = aws_db_instance.main.username
}

output "password" {
  value = aws_db_instance.main.password
}

output "connection_url" {
  sensitive = true
  value = "postgres://${aws_db_instance.main.username}:${aws_db_instance.main.password}@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${aws_db_instance.main.name}"
}

output "connection_security_group_id" {
  value = aws_db_subnet_group.subnet_group.id
}
