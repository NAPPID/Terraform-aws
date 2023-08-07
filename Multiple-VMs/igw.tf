resource "aws_internet_gateway" "nap-igw" {
  vpc_id = aws_vpc.nap-vpc.id
  tags = {
    "Name" = "${var.env}-igw"
  }
}