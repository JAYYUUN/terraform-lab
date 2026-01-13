# 서울 리전: EC2, ALB
provider "aws" {
  region = "ap-northeast-2"
}

# 버지니아(us-east-1): CloudFront/WAF (CLOUDFRONT scope)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}