provider "aws" {
  region = var.AWS_REGION
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}