resource "aws_security_group" "schika_limited_SG" {
    vpc_id = aws_vpc.schika_limited.id
    name        = "Allow ssh and http and https"
    description = "Allows HTTPS, HTTP and SSH"

    ingress {
        description      = "HTTPS"
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
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
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
        Name = "schika_limited_SG"
    }
}

# db security group to allow only instance having the above security group to have access.
resource "aws_security_group" "schika_limited_SG_db" {
    vpc_id = aws_vpc.schika_limited.id
    name        = "Allow Database connection"
    description = "Allows Database connection"

    ingress {
        description      = "DB"
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        cidr_blocks      = var.default_cidr
        security_groups = [aws_security_group.schika_limited_SG.id]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = var.default_cidr
        ipv6_cidr_blocks = var.default_cidr_ipv6
    }

    tags = {
        Name = "schika_limited_SG_db"
    }
}