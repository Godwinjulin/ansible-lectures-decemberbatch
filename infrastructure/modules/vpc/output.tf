output "vpc_id" {
  value = aws_vpc.main[0].id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.main-public[*].id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.main-private[*].id
}

output "vpc_security_group_id" {
  description = "The ID of the security group created by default on Default VPC creation"
  value       = aws_security_group.sg[0].id
}
