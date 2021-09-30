variable "instance_ids" {
  type = list(string)
  description = "Instance IDs"
}

variable "vpc" {
  type = object({
    vpc_id = string
    subnet_ids = list(string)
  })
  description = "VPC"
}

variable "security_group_ids" {
  type = list(string)
  description = "Security group IDs for Load Balancer"
}
