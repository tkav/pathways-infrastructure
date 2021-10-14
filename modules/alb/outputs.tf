
output "alb_sg_id" {
  value       = aws_security_group.weather_app_alb_sg.id
  description = "ID of ALB security group."
}

output "lb_target_group_arn" {
  description = "Target Group ARN"
  value       = aws_lb_target_group.target_group.arn
}