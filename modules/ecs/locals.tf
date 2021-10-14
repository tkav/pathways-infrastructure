
locals {
  container_definitions = templatefile("${path.module}/container-definition.tpl", {
    name_prefix         = var.name_prefix
    aws_region          = var.aws_region
    cloudwatch_group    = var.cloudwatch_group
    ecr-repo-uri        = var.ecr_repo_uri
    execution-role-arn  = var.ecs_iam_role_arn
    port                = var.port
    memory              = var.memory
    cpu                 = var.cpu
  })
}
