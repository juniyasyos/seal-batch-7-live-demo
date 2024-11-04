output "private_subnets" {
  description = "private_subnets"
  value       = module.vpc.private_subnets
}
output "public_subnets" {
  description = "public_subnets"
  value       = module.vpc.public_subnets
}

output "rds_security_group_ids" {
  description = "security group ids returned for rds"
  value       = [aws_security_group.rds_security_group.id]
}
