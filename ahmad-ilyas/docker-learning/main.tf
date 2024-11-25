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

# module "wordpress" {
#   source                 = "./modules/database"
#   depends_on             = [module.myvpc]
#   db_name                = var.db_name_wordpress
#   username               = var.username_wordpress
#   password               = var.password_wordpress
#   port                   = var.port_wordpress
#   rds_tags_environment   = var.env
#   maintenance_window     = "Mon:00:00-Mon:03:00"
#   backup_window          = "03:00-06:00"
#   vpc_security_group_ids = module.myvpc.rds_security_group_ids
#   db_subnet_group_name   = "rds-subnet-group"
# }

# module "voteapps" {
#   source                 = "./modules/database"
#   depends_on             = [module.myvpc]
#   db_name                = var.db_name_voteapps
#   username               = var.username_voteapps
#   password               = var.password_voteapps
#   port                   = var.port_voteapps
#   rds_tags_environment   = var.env
#   maintenance_window     = "Mon:00:00-Mon:03:00"
#   backup_window          = "03:00-06:00"
#   vpc_security_group_ids = module.myvpc.rds_security_group_ids
#   db_subnet_group_name   = "rds-subnet-group"
# }

locals {
  instances = {
    # wordpress = {
    #   ami           = data.aws_ami.ubuntu.id
    #   instance_type = "t2.micro"
    # }
    # voteapps-server = {
    #   ami           = data.aws_ami.ubuntu.id
    #   instance_type = "t2.micro"
    # }
    minikube-learning = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.large"
    }
  }
}

resource "aws_instance" "this" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = module.myvpc.public_subnets[0]
  security_groups             = [module.myvpc.allow_ssh]
  associate_public_ip_address = true

  tags = {
    Name = each.key
  }
}
