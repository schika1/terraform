resource "aws_route_table" "schika_limited_rt_1" {
  vpc_id = aws_vpc.schika_limited.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.schika_IG.id
  }

  tags = {
    Name = "route table for public subnet"
    description = "route table use to route unknown traffic to the internet"
  }
}

# route table association for public subnets
resource "aws_route_table_association" "schika_public_1_RTA" {
  subnet_id = aws_subnet.schika_public_1.id
  route_table_id = aws_route_table.schika_limited_rt_1.id
}

resource "aws_route_table_association" "schika_public_2_RTA" {
  subnet_id = aws_subnet.schika_public_2.id
  route_table_id = aws_route_table.schika_limited_rt_1.id
}

resource "aws_route_table_association" "schika_public_3_RTA" {
  subnet_id = aws_subnet.schika_public_3.id
  route_table_id = aws_route_table.schika_limited_rt_1.id
}