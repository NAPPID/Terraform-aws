resource "aws_security_group" "nap-sg" {
  name   = "${var.env}-sg"
  vpc_id = aws_vpc.nap-vpc.id
}

resource "aws_security_group_rule" "nap-sg-ingress" {
  count             = length(var.ingress-rules)
  security_group_id = aws_security_group.nap-sg.id
  type              = "ingress"
  from_port         = var.ingress-rules[count.index].from_port
  to_port           = var.ingress-rules[count.index].to_port
  protocol          = var.ingress-rules[count.index].protocol
  cidr_blocks       = [var.ingress-rules[count.index].cidr_block]
  description       = var.ingress-rules[count.index].description
}

resource "aws_security_group_rule" "nap-sg-egress" {
  count             = length(var.egress-rules)
  security_group_id = aws_security_group.nap-sg.id
  type              = "egress"
  from_port         = var.egress-rules[count.index].from_port
  to_port           = var.egress-rules[count.index].to_port
  protocol          = var.egress-rules[count.index].protocol
  cidr_blocks       = [var.egress-rules[count.index].cidr_block]
  description       = var.egress-rules[count.index].description
}