
locals {
  all-tags = {
    name        = "${var.ENV}-${data.aws_region.region.name}-vpc"
    Application = "Nginx"
    #ENV = "dev"
  }

  #for_each = toset(module.deploy-ec2.pub-ip)
  #ips = [module.deploy-ec2.pub-ip[0]]
}

data "aws_region" "region" {
}

module "deploy-vpc" {
  source     = "../vpc"
  nat-enable = var.nat-require
  pub-subs   = var.pub-subs
  tags       = local.all-tags
  vpc        = var.vpc
}

module "deploy-sg" {
  source     = "../sg"
  sg-egress  = var.sg-egress
  sg-ingress = var.sg-ingress
  sg-tags    = local.all-tags
  vpc-id     = module.deploy-vpc.vpc-id

}

module "deploy-ec2" {
  source     = "../ec2"
  image-id   = var.ami-id
  key-name   = var.key
  count      = length(module.deploy-vpc.subnet-ids)
  pub-sub-id = [module.deploy-vpc.subnet-ids[count.index]]
  sg-ids     = [module.deploy-sg.sg-id]
  ENV        = var.ENV

}

output "ec2-public-ips" {
  value = module.deploy-ec2[*].pub-ip
}

output "pub-ip-list" {
  value = [
          for ip in module.deploy-ec2[*].pub-ip : ip
  ]
}
