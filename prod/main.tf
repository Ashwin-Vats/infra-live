module "backend" {
  source = "../../infra-modules/s3-backend"

  bucket_name         = "ashwin-prod-terraform-state"
  dynamodb_table_name = "ashwin-prod-terraform-locks"
  kms_key_alias       = "ashwin-prod-tf-key"
}

module "vpc" {
  source = "../../infra-modules/vpc"

  env = "prod"

  vpc_cidr = "10.2.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  public_subnets = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24"
  ]

  private_subnets = [
    "10.2.11.0/24",
    "10.2.12.0/24",
    "10.2.13.0/24"
  ]
}

module "iam" {
  source = "../../infra-modules/iam"

  env = "prod"
  account_id = "d125788629837"
  cluster_name = var.cluster_name
}

module "security_groups" {
  source = "../../infra-modules/security_groups"

  env    = "prod"

  vpc_id = module.vpc.vpc_id
}

module "kms" {
  source = "../../infra-modules/kms"

  env = "prod"
  account_id = "d125788629837"

}

module "bastion" {
  source = "../../infra-modules/bastion"

  env = "prod"

  public_subnets = module.vpc.public_subnets

  bastion_sg_id = module.security_groups.bastion_sg_id

  key_name = "prod-bastion-key"
}


module "kops_s3" {
  source = "../../infra-modules/kops-s3"

  env = "prod"

  account_id = "d125788629837"
  region     = "ap-south-1"
  kms_key_arn = module.kms.kms_key_arn
}

module "dns" {
  source = "../../infra-modules/dns"

  env = "prod"

  domain_name = "corp.example.internal"

  vpc_id = module.vpc.vpc_id
}


# module "kops_oidc" {
#   source = "../../infra-modules/kops-oidc"

#   env = "prod"

#   cluster_name = var.cluster_name
# }