
resource "aws_key_pair" "KEY" {
  key_name   = "KEY"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "Tomcat_Server" {
    vpc_security_group_ids = [aws_security_group.tomcat_SG.id]
    key_name = aws_key_pair.KEY.key_name
    ami = var.ami
    instance_type = var.instance_type
    associate_public_ip_address = true    
    connection {
        type        = "ssh"
        user        = "ec2-user"
        private_key = file(var.PATH_TO_PRIVATE_KEY)
        host        = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
             "#!/bin/bash",
            "sudo yum update -y",
            "sudo yum ugrade -y",
            "sudo echo 'this is a test' > file1",
            "sudo yum install wget -y",
            "sudo yum install java-11-openjdk-devel -y",
            "cd /usr/local",
            "sudo wget https://ftp.heanet.ie/mirrors/www.apache.org/dist/tomcat/tomcat-10/v10.0.6/bin/apache-tomcat-10.0.6.tar.gz",
            "sudo tar -xvf apache-tomcat*",
            "sudo mv apache-tomcat-10.0.6 tomcat10",
            "sudo rm -R apache-tomcat-10.0.6.tar.gz",
            "sudo useradd -r tomcat",
            "sudo chown -R tomcat:tomcat /usr/local/tomcat10    ",
            "sudo sed -i '23i<role rolename=\"manager-script\"/>'  /usr/local/tomcat10/conf/tomcat-users.xml",
            "sudo sed -i '24i<role rolename=\"manager-jmx\"/>'  /usr/local/tomcat10/conf/tomcat-users.xml",
            "sudo sed -i '25i<role rolename=\"manager-status\"/>'  /usr/local/tomcat10/conf/tomcat-users.xml",
            "sudo sed -i '26i<user username=\"admin\" password=\"Admin123\" roles=\"manager-gui,manager-script, manager-jmx, manager_status\"/>' /usr/local/tomcat10/conf/tomcat-users.xml",
            "sudo ed -i '27i<user username=\"deployer\" password=\"deployer\" roles=\"admin-script\"/>' /usr/local/tomcat10/conf/tomcat-users.xml",
            "sudo sed -i '28i<user username=\"tomcat\" password=\"Tomcat123\" roles=\"manager-gui\"/>' /usr/local/tomcat10/conf/tomcat-users.xml",
            "sudo systemctl daemon-reload",
            "sudo cd ./tomcat10/bin",
            "sudo ./startup.sh"
        ]
    }
  
    # user_data = <<-EOF
    # #!/bin/bash
    # sudo su
    # sudo echo 'this is a test' > file1
    # sudo yum install wget -y
    # sudo yum install java-11-openjdk-devel -y
    # cd /usr/local
    # sudo wget https://ftp.heanet.ie/mirrors/www.apache.org/dist/tomcat/tomcat-10/v10.0.6/bin/apache-tomcat-10.0.6.tar.gz
    # sudo tar -xvf apache-tomcat*
    # sudo mv apache-tomcat-10.0.6 tomcat10
    # sudo rm -R apache-tomcat-10.0.6.tar.gz
    # sudo useradd -r tomcat
    # sudo chown -R tomcat:tomcat /usr/local/tomcat10    
    # sudo sed -i '23i<role rolename="manager-script"/>'  /usr/local/tomcat10/conf/tomcat-users.xml
    # sudo sed -i '24i<role rolename="manager-jmx"/>'  /usr/local/tomcat10/conf/tomcat-users.xml
    # sudo sed -i '25i<role rolename="manager-status"/>'  /usr/local/tomcat10/conf/tomcat-users.xml
    # sudo sed -i '26i<user username="admin" password="Admin123" roles="manager-gui,manager-script, manager-jmx, manager_status"/>' /usr/local/tomcat10/conf/tomcat-users.xml
    # sudo ed -i '27i<user username="deployer" password="deployer" roles="admin-script"/>' /usr/local/tomcat10/conf/tomcat-users.xml
    # sudo sed -i '28i<user username="tomcat" password="Tomcat123" roles="manager-gui"/>' /usr/local/tomcat10/conf/tomcat-users.xml
    # sudo systemctl daemon-reload
    # cd ./tomcat10/bin
    # ./startup.sh
    # EOF
    tags = {
        Name = "Tomcat Server"
    }
}