variable "subnet_suffix" {
  description = "Suffix appended to subnet names"
  type        = list(string)
  default     = ["a", "b", "c"]
}

variable "aws_region" {
    description = "AWS Region"
    default = ""
}

variable "project_prefix" {
    description = "Project prefix to be used with component names"
    default = ""
}

variable "vpc_cidr_block" {
    description = "CIDR block for VPC"
    default = ""
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 1
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 1
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/28"]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.64/26"]
}