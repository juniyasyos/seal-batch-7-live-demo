variable "env" {
  description = "environment"
  type        = string
}
variable "vpc_name" {
  description = "name of vpc"
  type        = string
}
variable "cidr" {
  description = "cidr of vpc"
  type        = string
}
variable "azs" {
  description = "availability zones"
  type        = list(string)

}
variable "private_subnets" {
  description = "private subnets"
  type        = list(string)

}
variable "public_subnets" {
  description = "public subnets"
  type        = list(string)

}
variable "enable_nat_gateway" {
  description = "enable nat gateway"
  type        = bool
}
variable "enable_vpn_gateway" {
  description = "enable vpn gateway"
  type        = bool
}

variable "aws_region" {
  description = "aws region"
  type        = string
}

variable "key_name" {
  description = "name of key pair"
  type        = string
}


variable "db_name_pixelfed" {
  description = "db_name"
  type        = string
}
variable "username_pixelfed" {
  description = "username"
  type        = string
}
variable "password_pixelfed" {
  description = "password"
  type        = string
}
variable "port_pixelfed" {
  description = "port"
  type        = number
}

variable "db_name_koel" {
  description = "db_name"
  type        = string
}
variable "username_koel" {
  description = "username"
  type        = string
}
variable "password_koel" {
  description = "password"
  type        = string
}
variable "port_koel" {
  description = "port"
  type        = number
}
