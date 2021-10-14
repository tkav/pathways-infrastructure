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
