variable "bucket" {
  type        = string
  description = "Specifies the name of a S3 Bucket."
  default     = "tkav-pathways-dojo"
  validation {
    condition     = length(var.bucket) > 2
    error_message = "Must provide a name for the S3 bucket."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags added to project resources."
  default     = {
    Owner   = "Tom Kavanagh"
    Project = "Pathways Dojo Weather App"
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

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default = [
    "10.0.1.0/28",
    "10.0.1.16/28",
    "10.0.1.32/28"
  ]
  validation {
    condition = alltrue([
      for o in var.public_subnet_cidr_blocks : can(regex("^(10(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-1])))|(172.((1[6-9])|(2[0-9])(3[0-1]))(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[2-9])|(2[0-9])|(3[0-1])))|(192.168(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[6-9])|(2[0-9])|(3[0-1])))|(127(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-2])))", o))
    ])
    error_message = "List values must be formatted as CIDR blocks (eg. 10.0.1.0/28)."
  }
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "10.0.1.64/26",
    "10.0.1.128/26",
    "10.0.1.192/26"
  ]
  validation {
    condition = alltrue([
      for o in var.private_subnet_cidr_blocks : can(regex("^(10(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-1])))|(172.((1[6-9])|(2[0-9])(3[0-1]))(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[2-9])|(2[0-9])|(3[0-1])))|(192.168(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){2}/((1[6-9])|(2[0-9])|(3[0-1])))|(127(.(([0-9]?[0-9])|(1[0-9]?[0-9])|(2[0-4]?[0-9])|(25[0-5]))){3}/([8-9]|(1[0-9])|(2[0-9])|(3[0-2])))", o))
    ])
    error_message = "List values must be formatted as CIDR blocks (eg. 10.0.1.64/26)."
  }
}

variable "public_subnet_count" {
  description = "Number of public subnets."
  type        = number
  default     = 3
  validation {
    condition     = var.public_subnet_count > 0
    error_message = "Number of subnets should be at least 1."
  }
}

variable "private_subnet_count" {
  description = "Number of private subnets."
  type        = number
  default     = 3
  validation {
    condition     = var.private_subnet_count > 0
    error_message = "Number of subnets should be at least 1."
  }
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