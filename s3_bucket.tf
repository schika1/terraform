resource "aws_s3_bucket" "csamcomapnys3" {
  bucket = "csamcomapnys3"
  acl    = "private"
  force_destroy = true

  tags = {
    Name = "csamcomapnys3"
  }
}