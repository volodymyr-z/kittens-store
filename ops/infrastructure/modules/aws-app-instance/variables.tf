variable "subnet_id" {
  type = string
  description = "subnet ID for AWS Instance"
}

variable "security_group_ids" {
  type = string
  description = "Security Group IDs for AWS Instance"
}

variable "project_name" {
  type        = string
  default     = "Kittens Store"
  description = "Project name"
}

variable "assigned_security_groups" {
  type = list(string)

  description = "Assigned Security group"
  default = []
}

variable "instance_count" {
  type        = string
  default = 2
  description = "How many instances to create"
}
