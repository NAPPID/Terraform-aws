
output "vpc-id" {
  value = aws_vpc.my-vpc.id
}

output "subnet-ids" {
  value = aws_subnet.pub-sub[*].id
  #value = [
   # for i in aws_subnet.pub-sub : i.id
  #]
}

output "igw-id" {
  value = aws_internet_gateway.my-igw.id
}