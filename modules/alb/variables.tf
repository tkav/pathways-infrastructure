
variable "name_prefix" {
  default     = ""
}

variable "vpc_id" {
  default     = ""
}

variable "alb_sg_id" {
  default     = ""
}

variable "public_subnets" {
  type        = list(string)
  default     = []
}

variable "log_bucket" {
  default     = ""
}

variable "tags" {
  default     = {}
}
