
resource "aws_ecr_repository" "ecr_repo" {
  name                 = "${var.ecr_prefix}-node-weather-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags

}

resource "aws_ssm_parameter" "save_ecr_repo_url" {
  name  = "/${var.ecr_prefix}/node-weather-app/ecr-repo-url"
  type  = "String"
  value = aws_ecr_repository.ecr_repo.repository_url

  tags = var.tags

}
