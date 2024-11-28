# Output untuk IP Public Instance
output "public_ips" {
  description = "Public IP addresses of all instances"
  value       = [for instance in aws_instance.this : instance.public_ip]
}

# Output untuk Subnet VPC
output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.devops_vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.devops_vpc.private_subnets
}

# Output untuk AMI yang Digunakan Instance
output "instance_ami_ids" {
  description = "AMI IDs used by instances"
  value       = [for instance in aws_instance.this : instance.ami]
}

# Output untuk Semua Security Groups di VPC
output "all_security_group_ids" {
  description = "All security group IDs in the VPC"
  value       = concat(
    module.devops_vpc.frontend_ids,
    module.devops_vpc.backend_ids
  )
}

# Output untuk Instance IDs
output "instance_ids" {
  description = "All EC2 instance IDs"
  value       = [for instance in aws_instance.this : instance.id]
}

# Output untuk Key Pair
output "key_pair_name" {
  description = "Key pair name used for EC2 instances"
  value       = module.devops_vpc.keypair
}
