terraform {
  backend "s3" {
    bucket         = "my-terraform-backend"
    key            = "mw/terraform.tfstate"
    region         = "cn-northwest-1"
    encrypt        = true
  }
}
