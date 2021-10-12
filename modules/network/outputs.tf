output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of VPC."
}

output "public_subnets" {
  value       = aws_subnet.public_subnet.*.id
  description = "List of public subnets"
}

output "private_subnets" {
  value       = aws_subnet.private_subnet.*.id
  description = "List of private subnets"
}

output "alb_sg_id" {
  value       = aws_security_group.weather_app_alb_sg.id
  description = "ID of ALB security group."
}

output "ecs_sg_id" {
  value       = aws_security_group.weather_app_ecs_sg.id
  description = "ID of ECS security group."
}