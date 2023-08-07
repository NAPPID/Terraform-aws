
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
terraform {
  required_version = "~>1.5.0"
  required_providers {
    aws = {
      version = "~>5.9.0"
    }
  }
}
