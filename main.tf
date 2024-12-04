module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  env =var.env
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  azs = var.azs
  account_no = var.account_no
  default_vpc_id = var.default_vpc_id
}




