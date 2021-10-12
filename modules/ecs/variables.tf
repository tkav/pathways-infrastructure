
variable "name_prefix" {
  default     = ""
}

variable "ecr_repo_uri" {
  default     = ""
}

variable "ecs_iam_role_id" {
  default     = ""
}

variable "lb_target_group_arn" {
  default     = ""
}

variable "private_subnets" {
  default     = ""
}

variable "tags" {
  default     = {}
}
