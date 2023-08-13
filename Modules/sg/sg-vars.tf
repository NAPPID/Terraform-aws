
variable "sg-ingress" {
  description = "Inbound rules"
  type        = list(map(any))
}

variable "sg-egress" {
  description = "Outbound rules"
  type        = list(map(any))
}

variable "vpc-id" {
  description = "VPC id for"
  type = string
}

variable "sg-tags" {
  description = "SG-tags for security group"
  type = map(string)
}