# Local values for reuse throughout
locals {
  project_name = "monitoring-project"
  environment  = "learning"
  region       = "us-east-1"
  key_name     = "devops-miniproject"

  # Definisi instance dengan detail
  instances = {
    testing-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
      sg            = module.devops_vpc.frontend_ids[0]
      subnet_id     = module.devops_vpc.public_subnets[1]
    },
    frontend-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t3.large"
      sg            = module.devops_vpc.frontend_ids[0]
      subnet_id     = module.devops_vpc.public_subnets[0]
    }
  }
}