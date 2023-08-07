resource "aws_route_table" "nap-route-table" {
  vpc_id = aws_vpc.nap-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nap-igw.id
  }
  tags = {
    "Name" = "${var.env}-route-table"
  }
}

resource "aws_route_table_association" "nap-route-associate" {
  count          = length(var.pub-sub)
  route_table_id = aws_route_table.nap-route-table.id
  subnet_id      = element(aws_subnet.nap-sub.*.id, count.index)
}