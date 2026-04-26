variable "project_name" {
    description = "Tên dự án, tiền tố cho các tài nguyên"
    type = string
}

variable "vpc_cidr_block" {
    description = "CIDR block cho VPC"
    type = string
}

variable "public_subnet_cidrs" {
    description = "Danh sách các CIDR block cho Public Subnets"
    type = list(string)
}

variable "private_subnet_cidrs" {
    description = "Danh sách các CIDR block cho Private Subnets"
    type = list(string)
}

variable "azs" {
    description = "Danh sách các Availability Zones"
    type = list(string)
}