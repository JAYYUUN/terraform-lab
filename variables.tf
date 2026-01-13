variable "domain_name" {
  description = "yunhwan.click" //CloudFront에 붙일 도메인 (예: app.example.com)
  type        = string
}

variable "hosted_zone_id" {
  description = "Z0221618ZF8NB44AUOWH" //Route53 Hosted Zone ID (예: Z123...)
  type        = string
}

/*
variable "origin_domain_name" {
  description = "flask-alb-85133251.ap-northeast-2.elb.amazonaws.com"//원본(Origin) 도메인 - 보통 ALB DNS (예: xxx.ap-northeast-2.elb.amazonaws.com)
  type        = string
}
*/