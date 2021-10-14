
variable "name_prefix" {
  default     = ""
}

variable "ecr_repo_uri" {
  default     = ""
}

variable "ecs_iam_role_arn" {
  default     = ""
}

variable "lb_target_group_arn" {
  default     = ""
}

variable "vpc_id" {
  default     = ""
}

variable "alb_sg_id" {
  default     = ""
}

variable "private_subnets" {
  type        = list
  default     = []
}

variable "desired_count" {
  type        = number
}

variable "memory" {
  type        = number
}

variable "cpu" {
  type        = number
}

variable "tags" {
  default     = {}
}
