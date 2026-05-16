variable "project_name" {
  description = "Tên dự án, tiền tố cho các tài nguyên"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-2"
}

variable "vpc_cidr_block" {
  description = "CIRD block cho VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Danh sách các CIDR block cho Public Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Danh sách các CIDR block cho Private Subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "azs" {
  description = "Danh sách các Availability Zones"
  type        = list(string)
  default     = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "ssh_allowed_ip" {
  description = "CIDR block được phép SSH vào Public EC2"
  type        = string
}

variable "ami_id" {
  description = "AMI ID cho EC2 instances"
  type        = string
  default     = "ami-098341ffb8b768450"
}

variable "instance_type" {
  description = "Loại instance cho EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Tên key pair để truy cập EC2 instances"
  type        = string
  default     = "lab1-key"
}
