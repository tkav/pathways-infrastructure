
resource "aws_security_group" "weather_app_ecs_sg" {
  name        = "${var.name_prefix}-weather-app-ecs-sg"
  description = "weather-app-ecs-sg"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "ECS"
      from_port        = var.port
      to_port          = var.port
      protocol         = "tcp"
      security_groups  = [var.alb_sg_id]
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self = false
    }
  ]

  egress = [
    {
      description      = ""
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = false
    }
  ]

  tags = {
    Name = "${var.name_prefix}-weather-app-ecs-sg"
  }
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
    task_role_arn      = var.ecs_iam_role_arn
    execution_role_arn = var.ecs_iam_role_arn

}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.name_prefix}-weather-app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  depends_on = [aws_ecs_task_definition.task_definition]

  network_configuration {
      subnets         = var.subnets
      security_groups = [aws_security_group.weather_app_ecs_sg.id]
  }

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = "${var.name_prefix}-weather-app"
    container_port   = var.port
  }

}