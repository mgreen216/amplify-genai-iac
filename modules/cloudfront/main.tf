resource "aws_cloudfront_distribution" "amplify_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for Amplify Platform - ${var.stage}"
  default_root_object = ""
  price_class         = "PriceClass_100"  # Use only North America and Europe edge locations
  
  # Frontend origin - pointing to the ALB
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "amplify-frontend-${var.stage}"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      
      # Keep alive for better performance
      origin_keepalive_timeout = 60
      origin_read_timeout      = 60
    }
    
    custom_header {
      name  = "X-CloudFront-Key"
      value = var.cloudfront_secret
    }
  }
  
  # API Gateway origin
  origin {
    domain_name = var.api_gateway_domain
    origin_id   = "amplify-api-${var.stage}"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  # Static assets - cached aggressively
  ordered_cache_behavior {
    path_pattern     = "/_next/static/*"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"
    
    forwarded_values {
      query_string = false
      headers      = []
      
      cookies {
        forward = "none"
      }
    }
    
    min_ttl                = 0
    default_ttl            = 31536000  # 1 year
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  # Images - cached with moderate TTL
  ordered_cache_behavior {
    path_pattern     = "*.jpg"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"
    
    forwarded_values {
      query_string = false
      headers      = ["Origin", "Accept"]
      
      cookies {
        forward = "none"
      }
    }
    
    min_ttl                = 0
    default_ttl            = 86400   # 1 day
    max_ttl                = 604800  # 1 week
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  ordered_cache_behavior {
    path_pattern     = "*.png"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"
    
    forwarded_values {
      query_string = false
      headers      = ["Origin", "Accept"]
      
      cookies {
        forward = "none"
      }
    }
    
    min_ttl                = 0
    default_ttl            = 86400   # 1 day
    max_ttl                = 604800  # 1 week
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  # WebP images
  ordered_cache_behavior {
    path_pattern     = "*.webp"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Accept"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400   # 1 day
    max_ttl                = 604800  # 1 week
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # AVIF images
  ordered_cache_behavior {
    path_pattern     = "*.avif"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Accept"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400   # 1 day
    max_ttl                = 604800  # 1 week
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # SVG images
  ordered_cache_behavior {
    path_pattern     = "*.svg"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Accept"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400   # 1 day
    max_ttl                = 604800  # 1 week
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # GIF images
  ordered_cache_behavior {
    path_pattern     = "*.gif"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Accept"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400   # 1 day
    max_ttl                = 604800  # 1 week
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # ICO images
  ordered_cache_behavior {
    path_pattern     = "*.ico"
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"

    forwarded_values {
      query_string = false
      headers      = ["Origin", "Accept"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400   # 1 day
    max_ttl                = 604800  # 1 week
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # API routes - minimal caching
  ordered_cache_behavior {
    path_pattern     = "/api/*"
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-api-${var.stage}"
    
    forwarded_values {
      query_string = true
      headers      = ["Authorization", "Content-Type", "Origin", "Accept"]
      
      cookies {
        forward = "all"
      }
    }
    
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  # Model list endpoint - cached
  ordered_cache_behavior {
    path_pattern     = "*/models"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-api-${var.stage}"
    
    forwarded_values {
      query_string = false
      headers      = ["Authorization"]
      
      cookies {
        forward = "none"
      }
    }
    
    min_ttl                = 0
    default_ttl            = 300   # 5 minutes
    max_ttl                = 3600  # 1 hour
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "amplify-frontend-${var.stage}"
    
    forwarded_values {
      query_string = true
      headers      = ["Host", "Authorization", "Accept"]
      
      cookies {
        forward = "all"
      }
    }
    
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    acm_certificate_arn            = var.certificate_arn
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
  
  # Web Application Firewall
  web_acl_id = var.waf_acl_id
  
  # Logging
  logging_config {
    include_cookies = false
    bucket          = var.logging_bucket
    prefix          = "cloudfront/"
  }
  
  tags = {
    Name        = "amplify-cdn-${var.stage}"
    Environment = var.stage
    Service     = "amplify"
  }
}