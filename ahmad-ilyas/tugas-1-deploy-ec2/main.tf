resource "aws_instance" "example_resource" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  credit_specification {
    cpu_credits = "unlimited"
  }
}