
nat-require = false
vpc         = "10.20.0.0/16"
pub-subs    = ["10.20.20.0/24", "10.20.30.0/24"]
ami-id      = "ami-0f9ce67dcf718d332"
key         = "NAP-key"
ENV         = "test"
sg-ingress = [
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
    description = "Allow HTTP"
  },
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    description = "Allow HTTPS"
  },
  {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_block  = "0.0.0.0/0"
    description = "Allow tomcat port"
  }
]

sg-egress = [
  {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_block  = "0.0.0.0/0"
    description = "Allow to get internet"
  }
]