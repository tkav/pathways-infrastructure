
variable "ecr_prefix" {
  type        = string
  description = "Prefix added to components."
  default     = "project"
  validation {
    condition     = length(var.ecr_prefix) > 1
    error_message = "Prefix needs to have at least 1 character."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags added to modules resources."
  default     = {}
}
