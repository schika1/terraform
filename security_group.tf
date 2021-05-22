resource "aws_security_group" "tomcat_SG" {
  vpc_id = aws_default_vpc.default.id
  description = "Allow tomcat server connection on port  8085"

  ingress {
    description = "SSH Rules for login into the server"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.default_cidr
  }
  
  ingress {
    description = "http rule"
    from_port   = var.tomcat_access_port
    to_port     = var.tomcat_access_port
    protocol    = "tcp"
    cidr_blocks = var.default_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.default_cidr
  }

  tags = {
    Name = "tomcat_sg_rules"
  }
}