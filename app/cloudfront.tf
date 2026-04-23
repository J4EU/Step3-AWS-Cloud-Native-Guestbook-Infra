# CloudFront 원본 액세스 제어
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "s3-oac"
  origin_access_control_origin_type = "s3"     # S3 원본 액세스 제어
  signing_behavior                  = "always" # 항상 서명
  signing_protocol                  = "sigv4"  # 서명 프로토콜
}

# CloudFront 배포
resource "aws_cloudfront_distribution" "main_dist" {
  enabled             = true
  is_ipv6_enabled     = true         # IPv6 활성화
  default_root_object = "index.html" # 기본 루트 객체

  # 원본 1: S3 (정적 웹사이트)
  origin {
    domain_name              = aws_s3_bucket.guestbook_s3.bucket_regional_domain_name
    origin_id                = "S3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
  }

  # 원본 2: ALB (API 서버)
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "ALBOrigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # 기본 캐시 동작 (S3로 전송)
  default_cache_behavior {
    target_origin_id       = "S3Origin"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  # 순서 지정 캐시 동작 (API 요청을 ALB로 전송)
  ordered_cache_behavior {
    path_pattern     = "/api/*" # API 요청 패턴
    target_origin_id = "ALBOrigin"

    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"

    # API는 보통 캐싱을 하지 않거나 헤더를 전달해야 함
    forwarded_values {
      query_string = true  # 쿼리 문자열 전달
      headers      = ["*"] # 모든 헤더를 ALB로 전달 (CORS 해결)
      cookies {
        forward = "all" # 모든 쿠키를 ALB로 전달
      }
    }
  }

  # 지역 제한
  restrictions {
    geo_restriction {
      restriction_type = "none" # 지역 제한 없음
    }
  }

  # 뷰어 인증서
  viewer_certificate {
    cloudfront_default_certificate = true # 기본 인증서 사용
  }
}
