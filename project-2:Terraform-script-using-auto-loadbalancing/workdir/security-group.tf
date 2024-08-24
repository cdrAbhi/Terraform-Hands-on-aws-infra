#aws_security_group Block
resource "aws_security_group" "custom-sg" {
  vpc_id = aws_vpc.custom-vpc.id

  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-${var.my-env}"
  }
  depends_on = [
    aws_vpc.custom-vpc
  ]


}
