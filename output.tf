output "s3_domain_name" {
  value = aws_s3_bucket.csamcomapnys3.bucket_domain_name
}
output "s3_regional_domain_name" {
  value = aws_s3_bucket.csamcomapnys3.bucket_regional_domain_name
}
output "s3_website_domain" {
  value = aws_s3_bucket.csamcomapnys3.website_domain
}

output "s3_website_endpoint" {
  value = aws_s3_bucket.csamcomapnys3.website_endpoint
}

output "web_server" {
  value = aws_instance.server_2_s3.public_ip
}