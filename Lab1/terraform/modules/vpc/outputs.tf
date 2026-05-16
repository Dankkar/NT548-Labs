output "vpc_id" {
  description = "ID của VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs của các Public Subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs của các Private Subnets"
  value       = aws_subnet.private[*].id
}

output "default_security_group_id" {
  description = "ID của Default Security Group"
  value       = aws_default_security_group.default.id
}

output "internet_gateway_id" {
  description = "ID của Internet Gateway"
  value       = aws_internet_gateway.main.id
}