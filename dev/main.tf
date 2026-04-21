module "backend" {
  source = "../../infra-modules/s3-backend"

  bucket_name         = "ashwin-dev-terraform-state"
  dynamodb_table_name = "ashwin-dev-terraform-locks"
  kms_key_alias       = "ashwin-dev-tf-key"
}