
variable "pub-subs" {
  description = "Public subnet id"
  type        = list(string)
}


variable "vpc" {
  type        = string
  description = "VPC CIDR block"
}

variable "nat-enable" {
  description = "Enabling NAT gateway"
  type = bool
}

variable "tags" {
  description = "Tags for all"
  type = map(string)
}