# Local values for reuse throughout
locals {
  project_name = "monitoring-project"
  environment  = "learning"
  region       = "us-east-1"
  key_name     = "devops-miniproject"

  # Definisi instance dengan detail
  instances = {
    backend-server-1 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
      subnet        = aws_subnet.private.id
      sg            = aws_security_group.backend.id
    },
    testing-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
      subnet        = aws_subnet.private.id
      sg            = aws_security_group.backend.id
    },
    frontend-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
      subnet        = aws_subnet.public.id
      sg            = aws_security_group.frontend.id
    }
  }
}
