
###############  VPC  ##################
resource "aws_vpc" "my-vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    "Name" = "NAP-VPC"
  }
}



################### subnets ###################

resource "aws_subnet" "public-sub" {
  cidr_block              = "10.20.30.0/24"
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "public-sub"
  }
}

resource "aws_subnet" "public-sub2" {
  cidr_block              = "10.20.40.0/24"
  vpc_id                  = aws_vpc.my-vpc.id
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "Public-sub2"
  }
}

resource "aws_subnet" "private-sub" {
  cidr_block        = "10.20.70.0/24"
  vpc_id            = aws_vpc.my-vpc.id
  availability_zone = "us-east-1a"
  #map_public_ip_on_launch = "true"
  tags = {
    "Name" = "private-sub"
  }
}

########### igw   #############################

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    "Name" = "my-igw"
  }
}


################## NAT ######################

resource "aws_eip" "NAT-eip" {
  tags = {
    "Name" = "NAT-eip"
  }
}

resource "aws_nat_gateway" "nat-gate" {
  subnet_id = aws_subnet.public-sub.id
  allocation_id = aws_eip.NAT-eip.id
  tags = {
    "Name" = "NAT-from-Terra"
  }
  depends_on = [ aws_instance.my-vm, aws_instance.private-vm, aws_eip.NAT-eip ]
}

############## Routing Table #################

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    "Name" = "Public-Route"
  }
}

resource "aws_route_table_association" "route-associate" {
  route_table_id = aws_route_table.my-route-table.id
  subnet_id      = aws_subnet.public-sub.id
}



resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gate.id
  }
  tags = {
    "Name" = "Private-route"
  }
}
resource "aws_route_table_association" "priv-rout-associate" {
  route_table_id = aws_route_table.private-route.id
  subnet_id      = aws_subnet.private-sub.id
}


##################  security groups  ##################
resource "aws_security_group" "my-sg" {
  vpc_id = aws_vpc.my-vpc.id
  name   = "my-sg"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "Allow SSH"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = -1
    description = "Allow going out"
  }
}

#################  VM  ########################

resource "aws_instance" "my-vm" {
  ami                    = "ami-0f9ce67dcf718d332"
  instance_type          = "t2.micro"
  key_name               = "NAP-key"
  subnet_id              = aws_subnet.public-sub.id
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  tags = {
    "Name" = "my-ec2-vm"
  }
  provisioner "file" {
    source      = "resouurce.tf"
    destination = "/tmp/resource.tf"
  }
  provisioner "remote-exec" {
    inline = [
      "ls -lrt /tmp",
      "touch file1",
      "ls -lrt"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("NAP-key.pem")
    #agent       = "false"
    host = self.public_ip
  }
}

resource "aws_instance" "private-vm" {
  ami                    = "ami-0f9ce67dcf718d332"
  instance_type          = "t2.micro"
  key_name               = "NAP-key"
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  subnet_id              = aws_subnet.private-sub.id
  tags = {
    "Name" = "Priate-VM"
  }
}

output "pub-ip" {
  value = aws_instance.my-vm.public_ip
}

output "private-vm-ip" {
  value = aws_instance.private-vm.private_ip
}

output "private-vm-pip" {
  value = aws_instance.private-vm.public_ip
}