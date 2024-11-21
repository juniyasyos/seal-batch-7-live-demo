# Local values for reuse throughout
locals {
  project_name          = "monitoring-project"
  environment           = "learning"
  region                = "us-east-1"
  key_name              = "monitoring"
  instances = {
    learnig-monitoring = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.small"
    }
    testing-server-grafana-k6 = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = "t2.micro"
    }
  }
}
