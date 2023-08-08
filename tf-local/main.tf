terraform {
  required_version = "~>1.5.0"
  required_providers {
    local = {
      version = "~>2.4.0"
      #source = "hashicorp/terraform-provider-local"
    }
  }
}

provider "local" {

}