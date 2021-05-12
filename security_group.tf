resource "aws_security_group" "default_SG" {
    vpc_id = aws_vpc.schika_limited.id
    name        = "Allow ssh and http and https"
    description = "llow ssh and http and https"

    ingress {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        security_groups  = [aws_security_group.schika-elb-securitygroup.id] # the elastic loadbalancer has access to the web port
    }

    ingress {
        description      = "SSH"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = var.default_cidr
        ipv6_cidr_blocks = var.default_cidr_ipv6
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = var.default_cidr
        ipv6_cidr_blocks = var.default_cidr_ipv6
    }

    tags = {
        Name = "allow_tls"
    }
}

# security group for elb
resource "aws_security_group" "schika-elb-securitygroup" {
  vpc_id      = aws_vpc.schika_limited.id
  name        = "schika-elb-sg"
  description = "security group for Elastic Load Balancer"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "schika-elb-sg"
  }
}
