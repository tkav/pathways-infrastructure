
variable "bucket" {
  default     = ""
}

variable "tags" {
  default     = {}
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  acl    = "private"

  tags   = var.tags
}

output "s3_bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_name_arn" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.arn
}