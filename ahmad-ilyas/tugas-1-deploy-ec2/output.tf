output "test_server_public_ip" {

  description = "My test output for EC2 public IP"

  value = aws_instance.example_resource.public_ip

  sensitive = true

}

output "public_url" {

  description = "Public URL for my web server"

  value = "https://${aws_instance.example_resource.public_ip}:8000/index.html"

}