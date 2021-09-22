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
