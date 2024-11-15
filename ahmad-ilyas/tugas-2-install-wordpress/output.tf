output "public_url" {
  description = "Public URL for my web server"
  value = "http://${aws_instance.wordpress.public_ip}"
}

output "rds_endpoing" {
  value = aws_db_instance.rds_instance.endpoint
}