variable "project_name" {
    description = "Tên dự án, tiền tố cho các tài nguyên"
    type = string
}

variable "vpc_id" {
    description = "ID của VPC"
    type = string
}

variable "ssh_allowed_ip" {
    description = "IP hoặc CIDR block được phếp SSH vào Public EC2"
    type = string
}
