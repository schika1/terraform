#Define External IP 
resource "aws_eip" "schika-nat" {
  vpc = true
}

# define nat gateway
resource "aws_nat_gateway" "schika-nat-gw" {
  allocation_id = aws_eip.schika-nat.id #this defines the ip address to connect to this nat.
  subnet_id     = aws_subnet.schika_public_1.id
  depends_on    = [aws_internet_gateway.schika_IG]
}

#aws routetable association for nat
resource "aws_route_table" "schika-private" {
  vpc_id = aws_vpc.schika_limited.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.schika-nat-gw.id
  }

  tags = {
    Name = "schika-private"
  }
}

# route table association for private subnets
resource "aws_route_table_association" "schika_private_1_RTA" {
  subnet_id = aws_subnet.schika_private_1.id
  route_table_id = aws_route_table.schika-private.id
}

resource "aws_route_table_association" "schika_private_2_RTA" {
  subnet_id = aws_subnet.schika_private_2.id
  route_table_id = aws_route_table.schika-private.id
}

resource "aws_route_table_association" "schika_private_3_RTA" {
  subnet_id = aws_subnet.schika_private_3.id
  route_table_id = aws_route_table.schika-private.id
}

