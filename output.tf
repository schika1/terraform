output "tomcat_server" {
  description = "tomcat_server ip address"
  value = aws_instance.Tomcat_Server.public_ip
}
output "vpc_id" {
  description = "vpc_id"
  value = aws_default_vpc.default.id
}

output "security_group_details" {
  description = "Security group details to verify we are ok with connections"
  value = aws_security_group.tomcat_SG
}