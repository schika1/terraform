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


## we can specify specific ip addresses that can access our server.name
## any ip address which do not fall in this range cannot access our server
## this is good for security in terms of application database server.
data "aws_ip_ranges" "eu_west_ip_range" {
    regions = ["eu-west-1","eu-west-2"] # allowed region whose ip address will be allowed to connect to our machine
    services = ["ec2"] # services talke about what service will be allowed
}

resource "aws_security_group" "sg-custom_eu_west" {
    name = "custom_us_east"

    ingress {
        from_port = "443"
        to_port = "443"
        protocol = "tcp"
        cidr_blocks = slice(data.aws_ip_ranges.us_east_ip_range.cidr_blocks, 0, 50) # cidr_blocks gotten from the aws_ip_range
    }

    
    tags = {
        CreateDate = data.aws_ip_ranges.us_east_ip_range.create_date
        SyncToken = data.aws_ip_ranges.us_east_ip_range.sync_token
    }
}