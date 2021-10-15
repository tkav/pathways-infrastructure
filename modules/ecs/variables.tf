
variable "name_prefix" {
  type        = string
  description = "Prefix added to components."
  default     = "project"
  validation {
    condition     = length(var.name_prefix) > 1
    error_message = "Prefix needs to have at least 1 character."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region to provision resources."
  default     = "us-east-1"
  validation {
    condition     = length(var.aws_region) >= 9
    error_message = "Valid AWS region required (eg. us-east-1)."
  }
}

variable "cloudwatch_group" {
  type        = string
  description = "ID of cloudwatch group."
  default     = ""
  validation {
    condition     = length(var.cloudwatch_group) > 0
    error_message = "Must provide a cloudwatch group ID."
  }
}

variable "ecr_repo_uri" {
  type        = string
  description = "ECR repository URL."
  default     = ""
  validation {
    condition     = length(var.ecr_repo_uri) > 0
    error_message = "Must provide an ECR repository URL."
  }
}

variable "ecs_iam_role_arn" {
  type        = string
  description = "ECS IAM Role ARN."
  default     = ""
  validation {
    condition     = length(var.ecs_iam_role_arn) > 0
    error_message = "Must provide an ECS IAM role ARN."
  }
}

variable "lb_target_group_arn" {
  type        = string
  description = "Load Balancer Target Group ARN."
  default     = ""
  validation {
    condition     = length(var.lb_target_group_arn) > 0
    error_message = "Must provide a Load Balancer Target Group ARN."
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

variable "alb_sg_id" {
  type        = string
  description = "Application Load Balancer Security Group."
  default     = ""
  validation {
    condition     = length(var.alb_sg_id) > 0
    error_message = "Must provide a security group ID for Application Load Balancer."
  }
}

variable "subnets" {
  type        = list
  default     = []
  description = "Subnet list for ECS"
}

variable "desired_count" {
  type        = number
  description = "Desired task count."
  default     = 1
  validation {
    condition     = var.desired_count > 0
    error_message = "Desired task count for ECS."
  }
}

variable "port" {
  type        = number
  description = "ECS container port."
  default     = 3000
  validation {
    condition     = var.port > 0
    error_message = "Must provide a valid container port."
  }
}

variable "memory" {
  type        = number
  description = "ECS container memory."
  default     = 512
  validation {
    condition     = can(var.memory == "512") || contains(range(1024, 30720, 1024), var.memory)
    error_message = "Invalid memory option. Depending on CPU size, value must be between 512 (MB) and 30720 (MB) and divisible by 1024."
  }
}

variable "cpu" {
  type        = number
  description = "ECS CPU size."
  default     = 256
  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.cpu)
    error_message = "Invalid CPU size. Valid values include 256, 512, 1024, 2048, 4096."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags added to modules resources."
  default     = {}
}
