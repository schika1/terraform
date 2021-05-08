data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "instance_key_pair" {
  key_name = "key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "apache_server" {
  #ami           = lookup(var.AMI, var.AWS_REGION)
  ami = "ami-0a8e758f5e873d1c1"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.instance_key_pair.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.schika_public_1.id
  vpc_security_group_ids = [aws_security_group.schika_limited_SG.id]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get install apache2 -y",
      "sudo apt-get update",
      "sudo apt-get install php -y",
      "sudo apt-get install libapache2-mod-php",
      "sudo apt-get install php-cli",
      "sudo apt-get install php-mysql -y",
      "sudo apt-get install php-gd -y",
      "sudo apt-get install php-imagick -y",
      "sudo apt-get install php-tidy -y",
      "sudo apt-get install php-xmlrpc -y",
      "sudo cd /etc/apache2/mods-enabled/",
      "sudo sed 's/index.php/index.html/1' dir.conf",
      "sudo sed 's/index.html/index.php/1' dir.conf",
      "sudo apt-get install mysql-client -y",
      "sudo cd /etc/php/7.4/apache2",
      "sudo sed 's/memory_limit = 160M/memory_limit = 256M/1' php.ini",
      "sudo sed 's/upload_max_filesize = 2M/upload_max_filesize = 64M/1' php.ini",
      "sudo systemctl start apache2.service"
    ]
  }

# connection for the provisioner
  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
  
  tags = {
    Name = "Apache Server"
  }

}