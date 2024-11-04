# locals variables
locals {
  instance_type = "t2.nano"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0" # version pinnning.
    }
  }
  required_version = "1.9.8"
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_instance" "hello_world" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.instance_type

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "hello_world_2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.instance_type

  tags = {
    Name = "HelloWorld2"
  }
}

resource "aws_instance" "hello_world_3" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = local.instance_type

  tags = {
    Name = "HelloWorld3"
  }
}

output "aws_instance_id" {
  value = aws_instance.hello_world.id
}

output "aws_instance_id_2" {
  value = aws_instance.hello_world_2.id
}

output "aws_instance_1_ip" {
  value = aws_instance.hello_world.public_ip
}

resource "null_resource" "hello_world" {
  provisioner "local-exec" {
    command = "echo Hello World!"
  }
}
