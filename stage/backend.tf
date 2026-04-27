terraform {
  backend "s3" {
    bucket         = "ashwin-stage-terraform-state"
    key            = "stage/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "ashwin-stage-terraform-locks"
    encrypt        = true
  }
}