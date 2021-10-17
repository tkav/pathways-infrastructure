variable "subnet_suffix" {
  description = "Suffix appended to subnet names"
  type        = list(string)
  default     = ["a", "b", "c"]
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

variable "project_prefix" {
  description = "Prefix added to components."
  default     = "project"
  validation {
    condition     = length(var.project_prefix) > 1
    error_message = "Prefix needs to have at least 1 character."
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.1.0/24"
  validation {
    condition = can(regex("^(10(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-1])))|(172.((1[6-9])|(2[0-9])(3[0-1]))(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[2-9])|(2[0-9])|(3[0-1])))|(192.168(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[6-9])|(2[0-9])|(3[0-1])))|(127(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-2])))", var.vpc_cidr_block))
    error_message = "Must be formatted as CIDR block (eg. 10.0.1.0/24)."
  }
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 1
  validation {
    condition     = var.public_subnet_count > 0
    error_message = "Number of subnets should be at least 1."
  }
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 1
  validation {
    condition     = var.private_subnet_count > 0
    error_message = "Number of subnets should be at least 1."
  }
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/28"]
  validation {
    condition = alltrue([
      for o in var.public_subnet_cidr_blocks : can(regex("^(10(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-1])))|(172.((1[6-9])|(2[0-9])(3[0-1]))(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[2-9])|(2[0-9])|(3[0-1])))|(192.168(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[6-9])|(2[0-9])|(3[0-1])))|(127(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-2])))", o))
    ])
    error_message = "List values must be formatted as CIDR blocks (eg. 10.0.1.0/28)."
  }
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.64/26"]
  validation {
    condition = alltrue([
      for o in var.private_subnet_cidr_blocks : can(regex("^(10(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-1])))|(172.((1[6-9])|(2[0-9])(3[0-1]))(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[2-9])|(2[0-9])|(3[0-1])))|(192.168(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[6-9])|(2[0-9])|(3[0-1])))|(127(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-2])))", o))
    ])
    error_message = "List values must be formatted as CIDR blocks (eg. 10.0.1.64/26)."
  }
}