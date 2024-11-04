module "db" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = var.db_name

  engine               = "mysql"
  engine_version       = "8.0"
  major_engine_version = "8.0"

  # DB parameter group
  family              = "mysql8.0"
  instance_class      = "db.t3.micro"
  allocated_storage   = 5
  skip_final_snapshot = true

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  iam_database_authentication_enabled = false
  storage_encrypted                   = false
  manage_master_user_password         = false

  vpc_security_group_ids = var.vpc_security_group_ids

  maintenance_window = var.maintenance_window
  backup_window      = var.backup_window

  tags = {
    Environment = var.rds_tags_environment
  }

  db_subnet_group_name = var.db_subnet_group_name

  deletion_protection = false
}
