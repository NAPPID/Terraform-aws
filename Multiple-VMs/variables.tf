variable "nap-vpc" {
  description = "VPC for NAP"
  type        = string
  default     = "192.168.0.0/16"
}

variable "pub-sub" {
  description = "Public subnet for NAP VPC"
  type        = list(string)
  default     = ["192.168.10.0/24", "192.168.20.0/24"]
}

variable "vm-region" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vm-ami" {
  description = "AMI for all VMs"
  type        = string
  default     = "ami-0f9ce67dcf718d332"
}

variable "key-name" {
  description = "Key Name"
  type        = string
  default     = "NAP-key"
}
variable "insta-type" {
  description = "Instance Size"
  type        = string
  default     = "t2.micro"
}
variable "env" {
  type        = string
  description = "Tag value for all resources"
  default     = "NAP"
}

variable "ingress-rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_block  = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Allow SSH"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Allos HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Allow HTTPS"
  }]
}

variable "egress-rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))

  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
      description = "Allow egress"
    }
  ]
}

