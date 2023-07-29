
resource "aws_vpc" "NAP-vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "NAP-vpc"
  }
}

### Public subnet ###
resource "aws_subnet" "NAP-publicsub" {
  availability_zone       = "us-east-1a"
  cidr_block              = "192.168.10.0/24"
  map_public_ip_on_launch = "true"
  vpc_id                  = aws_vpc.NAP-vpc.id
  tags = {
    "Name" = "NAP-publicsub"
  }
}

#### Private Subnet  ####

resource "aws_subnet" "NAP-privatesub" {
  availability_zone = "us-east-1b"
  cidr_block        = "192.168.20.0/24"
  vpc_id            = aws_vpc.NAP-vpc.id
  tags = {
    "Name" = "NAP-privatesub"
  }
}

#####  IGW  #####

resource "aws_internet_gateway" "NAP-igw" {
  vpc_id = aws_vpc.NAP-vpc.id
  tags = {
    "Name" = "NAP-igw"
  }
}

#resource "aws_internet_gateway_attachment" "NAP-igw-attach" {
#  internet_gateway_id = aws_internet_gateway.NAP-igw.id
#  vpc_id              = aws_vpc.NAP-vpc.id
#}

###### Routing Table #######

resource "aws_route_table" "NAP-public-route" {
  vpc_id = aws_vpc.NAP-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.NAP-igw.id
  }

}

resource "aws_route_table" "NAP-private-route" {
  vpc_id = aws_vpc.NAP-vpc.id
}



resource "aws_route_table_association" "NAP-route-associate" {
  route_table_id = aws_route_table.NAP-public-route.id
  subnet_id      = aws_subnet.NAP-publicsub.id
}

resource "aws_route_table_association" "NAP-private-associate" {
  route_table_id = aws_route_table.NAP-private-route.id
  subnet_id      = aws_subnet.NAP-privatesub.id
}

######## Security Group  #############################

resource "aws_security_group" "nap-sg-public" {
  vpc_id = aws_vpc.NAP-vpc.id
  name   = "NAP-sg-public"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }
}

resource "aws_security_group" "nap-sg-private" {
  vpc_id = aws_vpc.NAP-vpc.id
  name   = "Private-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}


############## VMs   ###############################

resource "aws_instance" "pub-vm" {
  ami = "ami-0f9ce67dcf718d332"
  #associate_public_ip_address = "true"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.NAP-publicsub.id
  key_name               = "NAP-key"
  vpc_security_group_ids = [aws_security_group.nap-sg-public.id]
  tags = {
    "Name" = "pub-vm"
  }

  depends_on = [aws_security_group.nap-sg-public]
}

resource "aws_instance" "pri-vm" {
  ami = "ami-0f9ce67dcf718d332"
  #associate_public_ip_address = "true"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.NAP-privatesub.id
  key_name               = "NAP-key"
  vpc_security_group_ids = [aws_security_group.nap-sg-private.id]
}



resource "aws_iam_user" "user" {
  name = "James-web"
  tags = {
    "Name" = "Appuser"
  }

}

data "aws_availability_zones" "zone" {
  state = "available"
}
