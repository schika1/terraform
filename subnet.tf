# Public subnet for availability zone a
resource "aws_subnet" "schika_public_1" {
  vpc_id     = aws_vpc.schika_limited.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "schika_limited_public_1"
  }
}

# Public subnet for availability zone b
resource "aws_subnet" "schika_public_2" {
  vpc_id     = aws_vpc.schika_limited.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "schika_limited_public_2"
  }
}

# Public subnet for availability zone c
resource "aws_subnet" "schika_public_3" {
  vpc_id     = aws_vpc.schika_limited.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-1c"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "schika_limited_public_3"
  }
}

# Private subnet for availability zone a
resource "aws_subnet" "schika_private_1" {
  vpc_id     = aws_vpc.schika_limited.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "schika_limmited_private_1"
  }
}

# Private subnet for availability zone b
resource "aws_subnet" "schika_private_2" {
  vpc_id     = aws_vpc.schika_limited.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "schika_limmited_private_2"
  }
}

# Private subnet for availability zone c
resource "aws_subnet" "schika_private_3" {
  vpc_id     = aws_vpc.schika_limited.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "eu-west-1c"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "schika_limmited_private_3"
  }
}