variable "ec2-map" {
  type        = map(any)
  description = "ec2-properties"
  default = {
    public-sub1 = {
      cidr_block = "10.96.60.0/24"
      region     = "us-east-1a"
    }
    public-sub2 = {
      cidr_block = "10.96.90.0/24"
      region     = "us-east-1b"
    }
  }
}

variable "pub-subnets" {
  type = list(string)
  default = [ "10.96.60.0/24", "10.96.90.0/24" ]
}

variable "pri-sub" {
  type        = list(string)
  description = "Private subnets from list"
  default     = ["10.96.10.0/24", "10.96.20.0/24", "10.96.30.0/24"]
}
variable "vpc-name" {
  type    = string
  default = "my-vpc"
}

variable "env" {
  type    = string
  default = "Dev"
}

variable "ec2-tags" {
  type = map(string)
  default = {
    "Name" = "value"
  }
}

variable "sg-ingress-rules" {
  type = map(any)
  default = {
    "allow-ssh" = {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_block = ["0.0.0.0/0"]
    }
    "allow_HTTP" = {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_block = ["0.0.0.0/0"]
    }
    "allow-HTTPS" = {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_block = ["0.0.0.0/0"]
    }
  }
}

variable "sg-egress-rules" {
  type = map(object({
    from_port = number
    to_port = number
    protocol = string
    cidr_block = list(string)
  }))

  default = {
    "allow-out-all" = {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_block = ["0.0.0.0/0"]
    }
  }
}