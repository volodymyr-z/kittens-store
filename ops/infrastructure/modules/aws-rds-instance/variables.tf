variable "name" {
  type = string
  description = "Name for RDS"
}

variable "vpc" {
  type = object({
    vpc_id = string
    subnet_ids = list(string)
  })
  description = "VPC information"
}

variable "assigned_security_groups" {
  type = list(string)

  description = "Assigned Security group for RDS"
  default = []
}
