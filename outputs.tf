/*
output "ec2_public_ip" {
  description = "Public IP of Flask EC2"
  value       = aws_instance.flask.public_ip
}
*/

output "alb_dns_name" {
  value = aws_lb.flask_alb.dns_name
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.this.domain_name
}


