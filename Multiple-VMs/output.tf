output "pub-ips" {
  value = aws_instance.pub-vm.*.public_ip
}