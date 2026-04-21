terraform {
  backend "s3" {
    bucket         = "ashwin-dev-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ashwin-dev-terraform-locks"
    encrypt        = true
  }
}