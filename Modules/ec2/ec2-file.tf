
locals {
  instance_size = "t2.micro"
  env = "Dev"
  application = "Nginx"
  zone = slice(data.aws_availability_zones.zones.names,0,length(var.pub-sub-id))
}

data "aws_availability_zones" "zones" {
  state = "available"
}

resource "aws_instance" "ec2-vm" {
  count         = length(var.pub-sub-id)
  ami           = var.image-id
  subnet_id     = element(var.pub-sub-id, count.index) #var.pubsub-id[count.index]
  instance_type = local.instance_size
  key_name = var.key-name
  vpc_security_group_ids = var.sg-ids
  tags = {
    Name = "${local.env}-iis-[count.index]-${local.zone[count.index]}"
    App  = local.application
  }

}