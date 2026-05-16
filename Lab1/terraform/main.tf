module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "keypair" {
  source = "./modules/keypair"

  project_name = var.project_name
  key_name     = var.key_name
}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  project_name        = var.project_name
  public_subnet_id    = module.vpc.public_subnet_ids[0]
  internet_gateway_id = module.vpc.internet_gateway_id
}

module "route_tables" {
  source = "./modules/route_tables"

  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
}

module "security_groups" {
  source = "./modules/security_groups"

  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  ssh_allowed_ip = var.ssh_allowed_ip
}

module "ec2_instances" {
  source = "./modules/ec2_instances"

  project_name      = var.project_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = module.keypair.key_name
  public_subnet_id  = module.vpc.public_subnet_ids[0]
  private_subnet_id = module.vpc.private_subnet_ids[0]
  public_ec2_sg_id  = module.security_groups.public_ec2_sg_id
  private_ec2_sg_id = module.security_groups.private_ec2_sg_id
}