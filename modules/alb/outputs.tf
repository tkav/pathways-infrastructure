
output "alb_sg_id" {
  value       = aws_security_group.weather_app_alb_sg.id
  description = "ID of ALB security group."
}
