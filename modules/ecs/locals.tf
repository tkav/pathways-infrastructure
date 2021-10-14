
locals {
  container_definitions = templatefile("${path.module}/container-definition.json", {
    name_prefix         = var.name_prefix
    ecr-repo-uri        = var.ecr_repo_uri
    execution-role-arn  = var.ecs_iam_role_arn
    port                = var.port
    memory              = var.memory
    cpu                 = var.cpu
  })
}
