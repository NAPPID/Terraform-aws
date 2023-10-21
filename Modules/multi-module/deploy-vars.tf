
variable "nat-require" {
  description = "NAT gateway choice"
  type        = bool
}

variable "vpc" {
  description = "VPC cidr block"
  type        = string
}

variable "pub-subs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "ENV" {
  description = "Environment"
  type        = string
}

variable "sg-ingress" {
  description = "Inbound rules"
  type        = list(map(any))
}

variable "sg-egress" {
  description = "Outbound rules"
  type        = list(map(any))
}

variable "ami-id" {
  description = "AMI id"
  type        = string
}

variable "key" {
  description = "Keyname"
  type        = string
}

