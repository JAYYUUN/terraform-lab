resource "aws_acm_certificate" "cf_cert" { // 나의 도메인에 사용할 인증서 생성
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS" // 내가 도메인의 소유자임을 입증할 방식 설정 

  lifecycle {
    create_before_destroy = true // 기존 리소스를 지우기 전에, 새 리소스를 먼저 만듦. ACM 인증서는 생성되는데 수 분 이상이 걸릴 수 있으므로 미리 만들어져 있어야 함. 
  }
}

resource "aws_route53_record" "cf_cert_validation" { //도메인이 내 소유임을 증명 : ACM이 내게 준 검증용 레코드를 도메인에 등록하여 내 소유임을 증명해보임.

  zone_id = var.hosted_zone_id
  name    = tolist(aws_acm_certificate.cf_cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cf_cert.domain_validation_options)[0].resource_record_type
  records = [tolist(aws_acm_certificate.cf_cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cf_cert_validation" { //ACM이 요구한 DNS 검증 레코드를 다 만들어놨으니, ACM에게 직접 확인하고 인증서를 issued 상태로 만들라고 지시
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cf_cert.arn
  validation_record_fqdns = [aws_route53_record.cf_cert_validation.fqdn]
}
