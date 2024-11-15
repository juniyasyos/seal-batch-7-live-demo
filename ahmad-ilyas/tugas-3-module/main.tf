# deploy VPC
module "myvpc" {
  source   = "./modules/network"
  vpc_name = var.vpc_name
  env      = var.env
  cidr     = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway
  key_name           = var.key_name
}


# deploy RDS
module "myrds" {
  source                 = "./modules/database"
  depends_on             = [module.myvpc]
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  port                   = var.port
  rds_tags_environment   = var.env
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"
  vpc_security_group_ids = module.myvpc.rds_security_group_ids
  db_subnet_group_name   = "rds-subnet-group"
}
