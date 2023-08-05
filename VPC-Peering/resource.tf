
resource "aws_vpc" "NAP-vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "NAP-vpc"
  }
}

resource "aws_vpc" "NAP-vpc2" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "NAP-vpc2"
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

resource "aws_subnet" "NAP-publicsub2" {
  availability_zone       = "us-east-1a"
  cidr_block              = "10.20.30.0/24"
  map_public_ip_on_launch = "true"
  vpc_id                  = aws_vpc.NAP-vpc2.id
  tags = {
    "Name" = "NAP-publicsub2"
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

resource "aws_subnet" "NAP-privatesub2" {
  availability_zone = "us-east-1b"
  cidr_block        = "10.20.40.0/24"
  vpc_id            = aws_vpc.NAP-vpc2.id
  tags = {
    "Name" = "NAP-privatesub2"
  }
}

#####  IGW  #####

resource "aws_internet_gateway" "NAP-igw" {
  vpc_id = aws_vpc.NAP-vpc.id
  tags = {
    "Name" = "NAP-igw"
  }
}

resource "aws_internet_gateway" "NAP-igw2" {
  vpc_id = aws_vpc.NAP-vpc2.id
  tags = {
    "Name" = "NAP-igw2"
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
  route {
    cidr_block                = aws_vpc.NAP-vpc2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.Peering.id
  }
  tags = {
    "Name" = "Public-Route"
  }

}

resource "aws_route_table" "NAP-public-route2" {
  vpc_id = aws_vpc.NAP-vpc2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.NAP-igw2.id
  }
  route {
    cidr_block                = aws_vpc.NAP-vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.Peering.id
  }
  tags = {
    "Name" = "Public-Route2"
  }

}

resource "aws_route_table" "NAP-private-route" {
  vpc_id = aws_vpc.NAP-vpc.id
  tags = {
    "Name" = "Private-Route"
  }
}

resource "aws_route_table" "NAP-private-route2" {
  vpc_id = aws_vpc.NAP-vpc2.id
  tags = {
    "Name" = "Private-Route2"
  }
}



resource "aws_route_table_association" "NAP-route-associate" {
  route_table_id = aws_route_table.NAP-public-route.id
  subnet_id      = aws_subnet.NAP-publicsub.id
}

resource "aws_route_table_association" "NAP-route-associate2" {
  route_table_id = aws_route_table.NAP-public-route2.id
  subnet_id      = aws_subnet.NAP-publicsub2.id
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


resource "aws_security_group" "nap-sg-public2" {
  vpc_id = aws_vpc.NAP-vpc2.id
  name   = "NAP-sg-public2"
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

############## VMs   ###############################

resource "aws_instance" "pub-vm" {
  ami = "ami-0f34c5ae932e6f0e4"
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

resource "aws_instance" "pub-vm2" {
  ami                         = "ami-0f34c5ae932e6f0e4"
  associate_public_ip_address = "true"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.NAP-publicsub2.id
  key_name                    = "NAP-key"
  vpc_security_group_ids      = [aws_security_group.nap-sg-public2.id]
  tags = {
    "Name" = "pub-vm2"
  }
}


####################  Peering ###########################

resource "aws_vpc_peering_connection" "Peering" {
  vpc_id      = aws_vpc.NAP-vpc.id
  peer_vpc_id = aws_vpc.NAP-vpc2.id
  auto_accept = "true"
  tags = {
    "Name" = "peering"
  }
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  vpc_peering_connection_id = aws_vpc_peering_connection.Peering.id
  auto_accept               = "true"
  tags = {
    "Name" = "Accepter"
  }
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
