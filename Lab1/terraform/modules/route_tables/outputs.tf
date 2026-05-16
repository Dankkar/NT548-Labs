output "public_route_table_id" {
  description = "ID của Public Route Table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID của Private Route Table"
  value       = aws_route_table.private.id
}