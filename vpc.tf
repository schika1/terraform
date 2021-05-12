resource "aws_vpc" "schika_limited" {
   cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "schika_limited"
  }
}