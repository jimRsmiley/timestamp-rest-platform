resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
}

resource "aws_route_table_association" "main" {
  count = 2

  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.default.id
}
