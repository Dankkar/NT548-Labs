variable "project_name" {
    description = "Tên dự án, tiền tố cho các tài nguyên"
    type = string
}

variable "vpc_id" {
    description = "ID của VPC"
    type = string
}

variable "public_subnet_ids" {
    description = "Danh sách các ID của Public Subnets"
    type = list(string)
}

variable "private_subnet_ids" {
    description = "Danh sách các ID của Private Subnets"
    type = list(string)
}

variable "internet_gateway_id" {
    description = "ID của Internet Gateway"
    type = string
}

variable "nat_gateway_id" {
    description = "ID của NAT Gateway"
    type = string
}
