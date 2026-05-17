variable "project_name" {
  description = "Tên dự án, tiền tố cho các tài nguyên"
  type        = string
}

variable "ami_id" {
  description = "AMI ID cho EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Loại instance cho EC2 instances"
  type        = string 
}

variable "key_name" {
  description = "Tên key pair để truy cập EC2 instances"
  type        = string
}

variable "public_subnet_id" {
  description = "ID của Public Subnet để triển khai Public EC2"
  type        = string
}

variable "private_subnet_id" {
  description = "ID của Private Subnet để triển khai Private EC2"
  type        = string
}

variable "public_ec2_sg_id" {
  description = "ID của Security Group cho Public EC2"
  type        = string
}

variable "private_ec2_sg_id" {
  description = "ID của Security Group cho Private EC2"
  type        = string
}