resource "aws_db_subnet_group" "mariadb" {
  name        = "mariadb-subnets"
  description = "Amazon RDS subnet group"
  subnet_ids  = [aws_subnet.schika_private_1.id, aws_subnet.schika_private_2.id, aws_subnet.schika_private_3.id] #subnet groups of the database
}

# db parameter group mysql 5.7
resource "aws_db_parameter_group" "mariadb-parameters" {
  name   = "rds-pg"
  family = "mysql5.7"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

# db instance mysql 5.7
resource "aws_db_instance" "schika_mariadb" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username                = "root"           # username
  password                = "mariadb141"     # password
  db_subnet_group_name    = aws_db_subnet_group.mariadb.name
  parameter_group_name    = aws_db_parameter_group.mariadb-parameters.name
  multi_az                = "false"            # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.schika_limited_SG_db.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                          # how long you’re going to keep your backups
  availability_zone       = aws_subnet.schika_private_1.availability_zone # prefered AZ
  skip_final_snapshot  = true

  tags = {
    Name = "schika-mariadb"
  }
  
}