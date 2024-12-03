module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  env =var.env
  public_subnets = var.public_subnets
  private_subnets = var.public_subnets
  azs = var.azs
}



