resource "aws_vpc" "nap-vpc" {
  cidr_block           = var.nap-vpc
  enable_dns_hostnames = "true"
  tags = {
    "Name" = "${var.env}-vpc"
  }
}

resource "aws_subnet" "nap-sub" {
  vpc_id                  = aws_vpc.nap-vpc.id
  count                   = length(var.pub-sub)
  cidr_block              = element(var.pub-sub, count.index)
  availability_zone       = element(var.vm-region, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    "Name" = "${var.env}-publicsub-${count.index}"
  }
}
