variable "project_name" {
  description = "Tên dự án, làm tiền tố cho keypair"
  type        = string
}

variable "key_name" {
  description = "Tên key pair để truy cập EC2 instances"
  type        = string
}
