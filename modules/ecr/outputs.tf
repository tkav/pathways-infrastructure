
output "ecr_repo_url" {
  description = "ECR Repo URL"
  value       = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_iam_policy_id" {
  description = "Policy ID"
  value       = aws_iam_role_policy.ecr_iam_role_policy.id
}

output "ecr_iam_role_arn" {
  description = "ECR role ARN"
  value       = aws_iam_role.ecr_role.arn
}