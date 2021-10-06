
output "bucket_name" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name}"]
}

output "bucket_name_arn" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name_arn}"]
}

output "ecr_repo_url" {
  description = "ECR Repo URL"
  value       = ["${module.ecr_repo.ecr_repo_url}"]
}