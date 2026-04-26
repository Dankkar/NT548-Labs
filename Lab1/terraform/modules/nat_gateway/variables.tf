variable "project_name" {
    description = "Tên dự án, tiền tố cho các tài nguyên"
    type = string
}

variable "public_subnet_id" {
    description = "ID của Public Subnet nơi NAT Gateway sẽ được triển khai"
    type = string
}

variable "internet_gateway_id" {
    description = "ID của Internet Gateway (để đảm bảo thứ tự triển khai)"
    type = string
}

