resource "aws_cloudfront_distribution" "this" {
  enabled = true
  comment = "CloudFront for ${var.domain_name}"

  aliases = [var.domain_name] // viewer에서 Cloudfront로 요청시 도메인 

  origin {
    domain_name = aws_lb.flask_alb.dns_name // CloudFront에서 ALB로 요청시 도메인
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "alb-origin"
    viewer_protocol_policy = "redirect-to-https" # HTTP로 오면 HTTPS로 리다이렉트 : 클라이언트 TO CloudFront

    allowed_methods = [
      "GET", "HEAD", "OPTIONS",
      "PUT", "POST", "PATCH", "DELETE"
    ]
    cached_methods = ["GET", "HEAD"]

    compress = true

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.cf_cert_validation.certificate_arn //CloudFront가 HTTPS 통신할 때 사용할 ‘검증 완료된 ACM 인증서’를 지정
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"

  }

  price_class = "PriceClass_200"

  tags = {
    Name = "cf-front-alb"
  }

  web_acl_id = aws_wafv2_web_acl.cf_waf.arn
}