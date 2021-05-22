
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
        user        = var.INSTANCE_USERNAME
        private_key = file(var.PATH_TO_PRIVATE_KEY)
        host        = self.public_ip
    }
  
    user_data = <<-EOF
    #!/bin/bash
    echo 'this is a test' > file1
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    sudo yum install wget -y
    sudo yum install java-11-openjdk-devel -y
    cd /usr/local
    sudo wget https://ftp.heanet.ie/mirrors/www.apache.org/dist/tomcat/tomcat-10/v10.0.6/bin/apache-tomcat-10.0.6.tar.gz
    sudo tar -xvf apache-tomcat*
    sudo mv apache-tomcat-10.0.6 tomcat10
    sudo rm -R apache-tomcat-10.0.6.tar.gz
    sudo useradd -r tomcat
    sudo chown -R tomcat:tomcat /usr/local/tomcat10
    sudo cat << EOT > /etc/systemd/system/tomcat.service
    [Unit]
    Description=Apache Tomcat Server
    After=syslog.target network.target
    [Service]
    Type=forking
    User=tomcat
    Group=tomcat
    Environment=CATALINA_PID=/usr/local/tomcat10/temp/tomcat.pid
    Environment=CATALINA_HOME=/usr/local/tomcat10
    Environment=CATALINA_BASE=/usr/local/tomcat10
    ExecStart=/usr/local/tomcat10/bin/catalina.sh start
    ExecStop=/usr/local/tomcat10/bin/catalina.sh stop
    RestartSec=10
    Restart=always
    [Install]
    WantedBy=multi-user.target
    EOT
    sed -i '22i<role rolename="manager-gui"/>'  /usr/local/tomcat10/conf/tomcat-users.xml
    sed -i '23i<role rolename="manager-script"/>'  /usr/local/tomcat10/conf/tomcat-users.xml
    sed -i '24i<role rolename="manager-jmx"/>'  /usr/local/tomcat10/conf/tomcat-users.xml
    sed -i '25i<role rolename="manager-status"/>'  /usr/local/tomcat10/conf/tomcat-users.xml
    sed -i '26i<user username="admin" password="Admin123" roles="manager-gui,manager-script, manager-jmx, manager_status"/>' /usr/local/tomcat10/conf/tomcat-users.xml
    sed -i '27i<user username="deployer" password="deployer" roles="admin-script"/>' /usr/local/tomcat10/conf/tomcat-users.xml
    sed -i '28i<user username="tomcat" password="Tomcat123" roles="manager-gui"/>' /usr/local/tomcat10/conf/tomcat-users.xml
    sudo systemctl daemon-reload
    sudo systemctl start tomcat
    sudo systemctl enable tomcat
    sudo yum install vsftpd
    sudo systemctl enable vsftpd
    EOF

    tags = {
        Name = "Tomcat Server"
    }
}