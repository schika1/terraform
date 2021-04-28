resource "aws_security_group" "default_SG" {
    vpc_id = aws_default_vpc.default.id
    name        = "Allow ssh and http and https"
    description = "llow ssh and http and https"

    ingress {
        description      = "TLS from VPC"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = var.default_cidr
        ipv6_cidr_blocks = var.default_cidr_ipv6
    }

    ingress {
        description      = "HTTP"
        from_port        = 8080
        to_port          = 8080
        protocol         = "tcp"
        cidr_blocks      = var.default_cidr
        ipv6_cidr_blocks = var.default_cidr_ipv6
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