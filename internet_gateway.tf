resource "aws_internet_gateway" "schika_IG" {
  vpc_id = aws_vpc.schika_limited.id

  tags = {
    Name = "schika_limited_internet_gateway"
  }
}