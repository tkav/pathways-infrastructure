
locals {
  container_definitions = templatefile("${path.module}/container-definition.json", {
    ecr-repo-uri        = var.ecr_repo_uri
    execution-role-arn  = var.ecs_iam_role_id
  })
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name_prefix}-weather-app-cluster"

  tags = var.tags

}

resource "aws_ecs_task_definition" "task_definition" {
    family                  = "${var.name_prefix}-weather-app-fam"
    container_definitions   = local.container_definitions
}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.name_prefix}-weather-app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  iam_role        = var.ecs_iam_role_id

  depends_on = [aws_ecs_task_definition.task_definition]

  network_configuration {
      subnets = var.private_subnets
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "${var.name_prefix}-weather-app"
    container_port   = 3000
  }

}