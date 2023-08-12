
output "pub-ips" {
  value = {
    for i,ip in aws_instance.mypub-vm : ip.id => ip.public_ip
  }
}

#output "out-pub" {
#  value = aws_instance.mypub-vm[*].public_ip
#}

output "zones" {
  value = local.vm-zones
}