output "vpc_id" {
description = "ID của VPC đã tạo"
value = module.vpc.vpc_id
} 

output "public_subnet_ids" {
description = "IDs của các Public Subnets"
value = module.vpc.public_subnet_ids
} 

output "private_subnet_ids" {
description = "IDs của các Private Subnets"
value = module.vpc.private_subnet_ids
} 

output "public_ec2_public_ip" {
description = "Public IP của Public EC2 Instance"
value = module.ec2_instances.public_instance_public_ip
} 

output "private_ec2_private_ip" {
description = "Private IP của Private EC2 Instance"
value = module.ec2_instances.private_instance_private_ip
} 

output "public_ec2_security_group_id" {
description = "ID của Security Group cho Public EC2"
value = module.security_groups.public_ec2_sg_id
} 

output "private_ec2_security_group_id" {
description = "ID của Security Group cho Private EC2"
value = module.security_groups.private_ec2_sg_id
}