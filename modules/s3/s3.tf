
resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  acl    = "private"

  tags   = var.tags
}
