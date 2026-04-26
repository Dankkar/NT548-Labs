output "public_instance_id" {
    description = "ID của Public EC2 instance"
    value = aws_instance.public_instance.id
}

output "private_instance_id" {
    description = "ID của Private EC2 instance"
    value = aws_instance.private_instance.id
}

output "public_instance_public_ip" {
    description = "Public IP của Public EC2 instance"
    value = aws_instance.public_instance.public_ip
}

output "private_instance_private_ip" {
    description = "Private IP của Private EC2 instance"
    value = aws_instance.private_instance.private_ip
}