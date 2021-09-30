output "public_endpoint" {
  value = aws_lb.load_balancer_test.dns_name
}
