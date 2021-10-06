variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "tkav-pathways-dojo"
}

variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default     = {
    Owner   = "Tom Kavanagh"
    Project = "Pathways Dojo Weather App"
  }
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/28",
    "10.0.1.16/28",
    "10.0.1.32/28"
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.1.64/26",
    "10.0.1.128/26",
    "10.0.1.192/26"
  ]
}

variable "public_subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 3
}

variable "private_subnet_count" {
  description = "Number of private subnets"
  type        = number
  default     = 3
}