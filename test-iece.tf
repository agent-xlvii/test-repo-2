data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19.0"

  azs                = slice(data.aws_availability_zones.available.names, 0, 2)
  cidr               = "10.0.0.0/16"
  create_igw         = true
  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_dns_support   = true
  enable_dns_hostnames = true
}