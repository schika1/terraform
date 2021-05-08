output "server_ip" {
  description = "Web server public ip address"
  value = aws_instance.apache_server.public_ip
}

# output "rds" {
#   value = aws_db_instance.schika_mariadb.endpoint
# }
