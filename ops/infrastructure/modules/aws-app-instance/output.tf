output "public_ip" {
  value = aws_instance.main_instance.*.public_ip
}

output "instance_ids" {
  value = aws_instance.main_instance.*.id
}
