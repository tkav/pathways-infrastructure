
variable "name_prefix" {
  type        = string
  description = "Prefix added to components."
  default     = "project"
  validation {
    condition     = length(var.name_prefix) > 1
    error_message = "Prefix needs to have at least 1 character."
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create resources."
  default     = ""
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "Must provide a VPC ID."
  }
}

variable "subnets" {
  type        = list
  default     = []
  description = "Subnet list for ECS"
}

variable "log_bucket" {
  type        = string
  description = "Specifies the name of the S3 log bucket."
  default     = "s3-log-bucket"
  validation {
    condition     = length(var.log_bucket) > 2
    error_message = "Must provide a name for the S3 log bucket."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags added to modules resources."
  default     = {}
}
