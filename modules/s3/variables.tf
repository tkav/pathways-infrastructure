
variable "bucket" {
  type        = string
  description = "Specifies the name of a S3 Bucket."
  default     = "s3-bucket"
  validation {
    condition     = length(var.bucket) > 2
    error_message = "Must provide a name for the S3 bucket."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags added to modules resources."
  default     = {}
}
