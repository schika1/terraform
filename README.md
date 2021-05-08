# terraform
Terraform Projects deploying php and rds

1. Infrastructure provisioning using ec2 instance using ubuntu ami.
2. Set up some command to be carried out using the reomte exec provisioner to install apache, php etc and start up the server
3. The output file will display the endpoint address of the rds which can be copied to the server host in the index.php
4. Same endpoint can be used to log into the database through any mysqli client to create the db for our website.
5. Mysql-client has been installed using remote-exec to enable the server (apache2) to connect to the database because of our website.
6. We can ssh into our instance and upload the php file or use the following command
    a. ssh -i key ubuntu@ip_address
    b. cd /var/www/html/
    c. touch index.php
    d. nano index.php
    e. copy all the index.php file into the cmd
    f. save using ctrl + O
    g. exit using the ctl + X
    h. edit the /etc/apache2/mods-enabled/dir.conf
    i. put index.php before the index.html
    j. restart server:: sudo systemctl restart apache2.service

## if you have a standard website, you can use mysql clients to install the database and tables, upload the website files using ssh and you are up and running.

#Even without the php configuration, once the provisioning is done, the ip address when visited should serve the apache default page. 
