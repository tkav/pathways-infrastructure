
locals {
  container_definitions = templatefile("${path.module}/container-definition.json", {
    ecr-repo-uri        = var.ecr_repo_uri
  })
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name_prefix}-weather-app-cluster"

  tags = var.tags

}

resource "aws_ecs_task_definition" "task_definition" {
    family                  = "${var.name_prefix}-weather-app-fam"
    container_definitions   = local.container_definitions

    memory  = var.memory
    cpu     = var.cpu

    requires_compatibilities = [
      "FARGATE"
    ]
  
    network_mode       = "awsvpc"
    execution_role_arn = var.ecs_iam_role_arn

}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.name_prefix}-weather-app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_count
  iam_role        = var.ecs_iam_role_arn

  depends_on = [aws_ecs_task_definition.task_definition]

  network_configuration {
      subnets         = var.private_subnets
      security_groups = [var.ecs_sg_id]
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "${var.name_prefix}-weather-app"
    container_port   = 3000
  }

}