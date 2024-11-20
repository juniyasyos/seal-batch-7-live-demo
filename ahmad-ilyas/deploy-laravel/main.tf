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


# deploy RDS Koel
module "myrds" {
  source                 = "./modules/database"
  depends_on             = [module.myvpc]
  db_name                = var.db_name_koel
  username               = var.username_koel
  password               = var.password_koel
  port                   = var.port_koel
  rds_tags_environment   = var.env
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"
  vpc_security_group_ids = module.myvpc.rds_security_group_ids
  db_subnet_group_name   = "rds-subnet-group"
}

# deploy RDS Pixelfed 
module "pixelfed" {
  source                 = "./modules/database"
  depends_on             = [module.myvpc]
  db_name                = var.db_name_pixelfed
  username               = var.username_pixelfed
  password               = var.password_pixelfed
  port                   = var.port_pixelfed
  rds_tags_environment   = var.env
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"
  vpc_security_group_ids = module.myvpc.rds_security_group_ids
  db_subnet_group_name   = "rds-subnet-group"
}


locals {
  instances = {
    koel-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.large"
    }
    pixelfed-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.large"
    }
    rocketChat-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.large"
    }
    bookstack-server = {
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
