resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

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

# creating aws instance
resource "aws_instance" "server_2_s3" {
  #ami = lookup(var.AMI, var.AWS_REGION)
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.levelup_key.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.s3-role-instanceprofile.name
  
  tags = {
    Name = "S3 Bucket instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",  # Remove the spurious CR characters.
      "sudo apt install awscli -y",
      "echo 'Hi, This is a test file using iam policy for s3 bucket with amazon' > myfile.txt",
      "aws s3 cp myfile.txt s3://csamcomapnys3"
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_USERNAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }
}