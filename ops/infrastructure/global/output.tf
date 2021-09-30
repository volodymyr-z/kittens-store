output "vpc_id" {
  value = module.vpc.vpc_id
}

output "database_url" {
  sensitive = true
  value = module.rds.connection_url
}

output "database_host" {
  value = module.rds.host
}

output "public_endpoint" {
  value = module.load_balancer.public_endpoint
}

output "public_ips" {
  value = module.app_instance.public_ip
}
