#####################################
# CloudFront Settings
#####################################
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "mycode.rip"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = "${aws_s3_bucket.this.bucket_domain_name}"
    origin_id   = "mycode.rip"
    origin_path = "/application"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  price_class         = "PriceClass_All"
  default_root_object = "index.html"
  aliases             = ["mycode.rip"]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # custom_error_response {
  #   error_caching_min_ttl = 300
  #   error_code            = 404
  # }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cloudfront.arn}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1"
  }
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "mycode.rip"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${aws_lambda_function.lambda_edge_function_for_cloudfront.qualified_arn}"
    }

    min_ttl     = 0
    max_ttl     = 0
    default_ttl = 0
  }

  # Cache behavior with precedence 0
  # ordered_cache_behavior {
  #   path_pattern           = "*.html"
  #   allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  #   cached_methods         = ["GET", "HEAD"]
  #   target_origin_id       = "mycode.rip"
  #   viewer_protocol_policy = "redirect-to-https"
  #
  #   forwarded_values {
  #     query_string = false
  #
  #     cookies {
  #       forward = "none"
  #     }
  #   }
  #
  #   min_ttl     = 0
  #   default_ttl = 86400
  #   max_ttl     = 31536000
  #   compress    = true
  # }
}
