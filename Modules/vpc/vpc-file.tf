
data "aws_availability_zones" "zones" {
  all_availability_zones = "true"
  state                  = "available"
}

locals {
  zone   = slice(data.aws_availability_zones.avs.names, 0, length(var.pub-subs))
  vpc-id = aws_vpc.my-vpc.id
  all_tags = var.tags
}

data "aws_availability_zones" "avs" {
  state = "available"
}

resource "aws_vpc" "my-vpc" {
  cidr_block           = var.vpc
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags                 = local.all_tags
}

resource "aws_subnet" "pub-sub" {
  count             = length(var.pub-subs)
  cidr_block        = var.pub-subs[count.index]
  availability_zone = local.zone[count.index]
  map_public_ip_on_launch = "true"
  vpc_id            = local.vpc-id
  tags              = local.all_tags
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = local.vpc-id
  tags   = local.all_tags
}

resource "aws_nat_gateway" "my-natgate" {
  count = var.nat-enable ? 1 : 0
  subnet_id = aws_subnet.pub-sub[0].id

}

resource "aws_route_table" "nap-route" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    "Name" = "module-route"
  }
}

resource "aws_route_table_association" "table-assiciation" {
  route_table_id = aws_route_table.nap-route.id
  count = length(var.pub-subs)
  subnet_id = element(aws_subnet.pub-sub.*.id, count.index)
}