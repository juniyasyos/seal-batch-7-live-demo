module "devops_vpc" {
  source   = "./modules/network"
  vpc_name = "devops-mini-project"
  env      = "stagging"
  cidr     = "10.100.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  private_subnets = ["10.100.100.0/24", "10.100.200.0/24"]
  public_subnets  = ["10.100.10.0/24", "10.100.20.0/24", "10.100.30.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  key_name           = local.key_name
}

# EC2 Instances
resource "aws_instance" "this" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = module.devops_vpc.keypair
  subnet_id                   = each.value.subnet_id
  security_groups             = [each.value.sg]
  associate_public_ip_address = true

  tags = {
    Name        = each.key
    Project     = local.project_name
    Environment = local.environment
  }
}
