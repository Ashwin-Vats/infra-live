module "backend" {
  source = "../../infra-modules/s3-backend"

  bucket_name         = "ashwin-stage-terraform-state"
  dynamodb_table_name = "ashwin-stage-terraform-locks"
  kms_key_alias       = "ashwin-stage-tf-key"
}

module "vpc" {
  source = "../../infra-modules/vpc"

  env = "stage"

  vpc_cidr = "10.1.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  public_subnets = [
    "10.1.1.0/24",
    "10.1.2.0/24",
    "10.1.3.0/24"
  ]

  private_subnets = [
    "10.1.11.0/24",
    "10.1.12.0/24",
    "10.1.13.0/24"
  ]
}

module "iam" {
  source = "../../infra-modules/iam"

  env = "stage"
  account_id = "d125788629837"
  cluster_name = var.cluster_name
}

module "security_groups" {
  source = "../../infra-modules/security_groups"

  env    = "stage"

  vpc_id = module.vpc.vpc_id
}

module "kms" {
  source = "../../infra-modules/kms"

  env = "stage"
  account_id = "d125788629837"

}

module "bastion" {
  source = "../../infra-modules/bastion"

  env = "stage"

  public_subnets = module.vpc.public_subnets

  bastion_sg_id = module.security_groups.bastion_sg_id

  key_name = "stage-bastion-key"
}


module "kops_s3" {
  source = "../../infra-modules/kops-s3"

  env = "stage"

  account_id = "d125788629837"
  region     = "ap-south-1"
  kms_key_arn = module.kms.kms_key_arn
}

module "dns" {
  source = "../../infra-modules/dns"

  env = "stage"

  domain_name = "corp.example.internal"

  vpc_id = module.vpc.vpc_id
}


module "kops_oidc" {
  source = "../../infra-modules/kops-oidc"

  env = "stage"

  cluster_name = var.cluster_name
}