module "backend" {
  source = "../../infra-modules/s3-backend"

  bucket_name         = "ashwin-dev-terraform-state"
  dynamodb_table_name = "ashwin-dev-terraform-locks"
  kms_key_alias       = "ashwin-dev-tf-key"
}

module "vpc" {
  source = "../../infra-modules/vpc"

  env = "dev"

  vpc_cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24"
  ]
}

module "iam" {
  source = "../../infra-modules/iam"

  env = "dev"
}

module "security_groups" {
  source = "../../infra-modules/security_groups"

  env    = "dev"

  vpc_id = module.vpc.vpc_id
}

module "kms" {
  source = "../../infra-modules/kms"

  env = "dev"
  account_id = "d125788629837"

}

module "bastion" {
  source = "../../infra-modules/bastion"

  env = "dev"

  public_subnets = module.vpc.public_subnets

  bastion_sg_id = module.security_groups.bastion_sg_id

  key_name = "dev-bastion-key"
}


module "kops_s3" {
  source = "../../infra-modules/kops-s3"

  env = "dev"

  account_id = "d125788629837"
  region     = "ap-south-1"
  kms_key_arn = module.kms.kms_key_arn
}

# module "dns" {
#   source = "../../infra-modules/dns"

#   env = "dev"

#   domain_name = "corp.example.internal"

#   vpc_id = module.vpc.vpc_id
# }


module "kops_oidc" {
  source = "../../infra-modules/kops-oidc"

  env = "dev"

  cluster_name = "kops.dev.corp.example.internal"
}

#########################################
# Cluster IAM
#########################################

module "cluster_iam" {
  source = "../../infra-modules/cluster-iam"

  env = "dev"

  cluster_name     = "kops.dev.corp.example.internal"
  oidc_provider_arn = module.kops_oidc.oidc_provider_arn
  oidc_provider_url = module.kops_oidc.oidc_provider_url
}

#########################################
# Node IAM
#########################################

module "node_iam" {
  source = "../../infra-modules/node-iam"

  env = "dev"
}

#########################################
# ArgoCD IAM
#########################################

module "argocd_iam" {

  source = "../../infra-modules/argocd-iam"
  env = "dev"
  oidc_provider_arn =    module.kops_oidc.oidc_provider_arn

  oidc_provider_url =    module.kops_oidc.oidc_provider_url
}

#########################################
# Addons IRSA
#########################################

module "addons_irsa" {
  source = "../../infra-modules/addons-irsa"

  env = "dev"

  oidc_provider_arn =    module.kops_oidc.oidc_provider_arn

  oidc_provider_url =    module.kops_oidc.oidc_provider_url
}

#########################################
# ECR
#########################################

module "ecr" {
  source = "../../infra-modules/ecr"

  env = "dev"

  repository_name = "app"
}