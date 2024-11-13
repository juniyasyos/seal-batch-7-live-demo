output "db_host" {
  value = module.myrds.rds_endpoint
}

output "wordpress_url" {
  value = "http://${module.myvpc.aws_instance_public_ip}"
}
