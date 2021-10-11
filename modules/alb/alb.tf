
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
  security_groups    = slice(var.alb_sg_id, 0, 2)
  subnets            = [var.public_subnets]

  enable_deletion_protection = true

  access_logs {
    bucket  = var.log_bucket
    prefix  = "${var.name_prefix}-weather-app"
    enabled = true
  }

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