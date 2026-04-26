output "nat_gateway_id" {
    description = "ID của NAT Gateway"
    value = aws_nat_gateway.main.id
}

output "nat_eip_id" {
    description = "ID của Elastic IP cho NAT Gateway"
    value = aws_eip.nat.id
}
