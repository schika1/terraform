output "server_ip" {
  description = "Web server public ip address"
  value = aws_instance.nginx_server.public_ip
}