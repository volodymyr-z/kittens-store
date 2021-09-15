variable "location" {
  type        = string
  default     = "us-west-2"
  description = "Default region for AWS services"
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Default cidr block"
}

variable "subnets_number" {
  type        = string
  default     = 2
  description = "Number of subnets to create"
}

variable "routing_table_cidr" {
  type = string
  default = "0.0.0.0/0"
  description = "Cidr for Routing table"
}

variable "project_name" {
  type        = string
  default     = "Kittens Store VPC"
  description = "VPC name"
}
