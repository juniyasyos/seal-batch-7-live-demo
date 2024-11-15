variable "db_name" {
  description = "db_name"
  type        = string
}
variable "username" {
  description = "username"
  type        = string
}
variable "password" {
  description = "password"
  type        = string
}
variable "port" {
  description = "port"
  type        = number
}
variable "maintenance_window" {
  description = "maintenance_window"
  type        = string
}
variable "backup_window" {
  description = "backup_window"
  type        = string
}
variable "rds_tags_environment" {
  description = "rds_tags_environment"
  type        = string
}
variable "db_subnet_group_name" {
  description = "db_subnet_group_name"
  type        = string
}
variable "vpc_security_group_ids" {
  description = "vpc_security_group_ids"
  type        = list(string)
}

