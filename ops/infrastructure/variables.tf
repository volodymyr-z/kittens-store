variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "project_name" {
  type = string
  default = "Kittens Store"
}

variable "routing_table_cidr" {
  type = string
  default = "0.0.0.0/0"
}
