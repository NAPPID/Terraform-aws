
resource "aws_security_group" "my-sg" {
  vpc_id = var.vpc-id
  name   = "my-sg"
  tags   = var.sg-tags
}

resource "aws_security_group_rule" "my-sg-ingress" {
  security_group_id = aws_security_group.my-sg.id
  type              = "ingress"
  count = length(var.sg-ingress)
  from_port         = var.sg-ingress[count.index].from_port
  to_port           = var.sg-ingress[count.index].to_port
  protocol          = var.sg-ingress[count.index].protocol
  cidr_blocks       = [var.sg-ingress[count.index].cidr_block]
  description       = var.sg-ingress[count.index].description
}

resource "aws_security_group_rule" "my-sg-egress" {
  security_group_id = aws_security_group.my-sg.id
  type              = "egress"
  count = length(var.sg-egress)
  from_port         = var.sg-egress[count.index].from_port
  to_port           = var.sg-egress[count.index].to_port
  protocol          = var.sg-egress[count.index].protocol
  cidr_blocks       = [var.sg-egress[count.index].cidr_block]
  description       = var.sg-egress[count.index].description
}