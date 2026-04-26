output "key_name" {
  description = "Tên của key pair đã tạo"
  value       = aws_key_pair.this.key_name
}
