

resource "aws_security_group" "weather_app_alb_sg" {
  name        = "${var.name_prefix}-weather-app-alb-sg"
  description = "weather-app-alb-sg"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
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
    Name = "${var.name_prefix}-weather-app-alb-sg"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.name_prefix}-weather-app-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  tags = var.tags

}

resource "aws_lb" "alb" {
  name               = "${var.name_prefix}-weather-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.weather_app_alb_sg.id]
  subnets            = var.subnets

  # access_logs {
  #   bucket  = var.log_bucket
  #   prefix  = "${var.name_prefix}-weather-app"
  #   enabled = true
  # }

  tags = var.tags

}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

}
