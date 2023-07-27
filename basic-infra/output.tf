output "tfuser" {
  value = aws_iam_user.user.id
}

output "zones" {
  value = data.aws_availability_zones.zone.names
}

output "pub-ip" {
  value = aws_instance.pub-vm.public_ip
}

output "pri-pub-ip" {
  value = aws_instance.pri-vm.private_ip
}