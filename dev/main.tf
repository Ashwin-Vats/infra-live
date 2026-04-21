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
}