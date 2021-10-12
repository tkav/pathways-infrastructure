
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

variable "ecs_sg_id" {
  default     = ""
}

variable "private_subnets" {
  type        = list
  default     = []
}

variable "desired_count" {
  type     = number
}

variable "memory" {
  type     = number
}

variable "cpu" {
  type     = number
}

variable "tags" {
  default     = {}
}
