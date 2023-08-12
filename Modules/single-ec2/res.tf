
locals {

  all_tags = {
    Name = "${var.vpc-name}-eastus"
    Env  = "${var.vpc-name}-dev"
  }

  sub-tags = {
    Name = "pri-subnet"
    env  = "Development"
  }

  comm-tags = {
    owner = "Sai"
    Env   = var.env
  }
  zones = slice(data.aws_availability_zones.zones.names, 0, length(var.pri-sub))

  vm-zones = {
    for z,k in aws_subnet.pub-sub : z=>k.availability_zone 
  }
}
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.96.0.0/16"
  tags       = local.all_tags
}

resource "aws_subnet" "pub-sub" {
  #for_each          = var.ec2-map
  #cidr_block        = each.value.cidr_block
  #availability_zone = each.value.region
  count = length(var.pub-subnets)
  cidr_block = var.pub-subnets[count.index]
  availability_zone = local.zones[count.index]
  vpc_id            = aws_vpc.my-vpc.id
  map_public_ip_on_launch = "true"
  tags              = local.all_tags
}

resource "aws_subnet" "private-sub" {
  count             = length(var.pri-sub)
  cidr_block        = var.pri-sub[count.index]
  availability_zone = local.zones[count.index]
  vpc_id            = aws_vpc.my-vpc.id
  tags              = local.all_tags
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
  tags   = local.sub-tags
}

resource "aws_route_table" "my-route" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name  = "my-route"
    owner = "Sai"
    Env   = var.env
  }
  depends_on = [ aws_subnet.pub-sub,aws_subnet.private-sub ]
}

resource "aws_route_table_association" "my-route-asso" {
  route_table_id = aws_route_table.my-route.id
  #for_each       = aws_subnet.pub-sub
  #subnet_id      = each.value.id
  count = length(var.pub-subnets)
  subnet_id = element(aws_subnet.pub-sub.*.id, count.index)
  depends_on = [ aws_subnet.pub-sub, aws_subnet.private-sub ]
}

resource "aws_instance" "mypub-vm" {
  ami = "ami-0f9ce67dcf718d332"
  instance_type = "t2.micro"
  key_name = "NAP-key"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  #for_each = var.ec2-map
  #subnet_id = aws_subnet.pub-sub[each.key].id
  #for_each = aws_subnet.pub-sub
  #subnet_id = each.value.id
  #count = length(var.ec2-map)
  #for_each       = aws_subnet.pub-sub
  #subnet_id      = each.value.id
  count = length(var.pub-subnets)
  subnet_id = aws_subnet.pub-sub[count.index].id
  tags = {
    #"Zone" = each.value.availability_zone
    Name = "${var.env}-ec2"
  }
}

resource "aws_security_group" "mysg" {
  vpc_id = aws_vpc.my-vpc.id
  name = "${var.env}-sg"
  #for_each = var.sg-ingress-rules
  #ingress  {
   #  from_port = each.value.from_port
    # to_port = each.value.to_port
     #protocol = each.value.protocol
     #cidr_blocks = each.value.cidr_block
     #description = each.key
  #}

  dynamic "ingress" {
    for_each = var.sg-ingress-rules
    content {
     from_port = ingress.value.from_port
     to_port = ingress.value.to_port
     protocol = ingress.value.protocol
     cidr_blocks = ingress.value.cidr_block
     description = ingress.key
    }
  }

  dynamic "egress" {
    for_each = var.sg-egress-rules
    content {
      from_port = egress.value.from_port
      to_port = egress.value.to_port
      cidr_blocks = egress.value.cidr_block
      protocol = egress.value.protocol
      description = egress.key
    }
  }
}

data "aws_availability_zones" "zones" {
  state = "available"
}