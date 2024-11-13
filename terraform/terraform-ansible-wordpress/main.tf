# deploy VPC
module "myvpc" {
  source   = "./modules/myvpc"
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
  source                 = "./modules/myrds"
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

# create env.yml for ansible
resource "local_file" "env_file" {
  content  = <<EOT
  wordpress_db_host: ${split(":", module.myrds.rds_endpoint[0])[0]}
  wordpress_db_user: ${var.username}
  wordpress_db_password: ${var.password}
  wordpress_db_name: ${var.db_name}
  EOT
  filename = "${path.module}/env.yml"
}

# call ansible command to install wordpress inside docker
resource "null_resource" "execute_ansible" {
  depends_on = [module.myrds, module.myvpc]
  provisioner "remote-exec" {
    connection {
      host        = module.myvpc.aws_instance_public_ip
      user        = "ubuntu"
      private_key = file("${path.module}/${var.key_name}_${var.env}.pem")
    }

    inline = ["echo 'connected!'"]
  }

  provisioner "local-exec" {
    command     = "ansible-playbook ./playbooks/install_docker_wordpress.yml --extra-vars '@env.yml'"
    working_dir = path.module
  }
}
