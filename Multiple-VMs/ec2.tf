
resource "aws_instance" "pub-vm" {
  count         = length(var.pub-sub)
  ami           = var.vm-ami
  instance_type = var.insta-type
  key_name      = var.key-name
  subnet_id     = element(aws_subnet.nap-sub.*.id, count.index)
  #security_groups = [aws_security_group.nap-sg]
  vpc_security_group_ids = [aws_security_group.nap-sg.id]
  user_data              = <<EOF
  #!/bin/bash
  yum update -y
  amazon-linux-extras install nginx1.12 -y
  service nginx start
  chkconfig nginx on
  echo '<h1> webserver-"${count.index+1}"</h1>' >> /usr/share/nginx/html/index.html
  EOF

  tags = {
    "Name" = "pub-vm-${count.index+1}"
  }
}