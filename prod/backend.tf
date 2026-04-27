terraform {
  backend "s3" {
    bucket         = "ashwin-prod-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ashwin-prod-terraform-locks"
    encrypt        = true
  }
}