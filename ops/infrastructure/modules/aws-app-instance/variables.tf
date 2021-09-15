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
