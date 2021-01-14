resource "aws_eip" "gw" {
  count = 2
  vpc   = true
}

resource "aws_nat_gateway" "gw" {
  count         = 2
  allocation_id = aws_eip.gw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "tf-ngw-${var.project_name}-${count.index}"
  }
}
