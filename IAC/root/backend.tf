terraform {
  backend "s3" {
    bucket         = "svazbv-bucket"
    key            = "mw/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
