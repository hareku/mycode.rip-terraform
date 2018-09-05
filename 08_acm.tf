#####################################
# ACM Settings
#####################################
resource "aws_acm_certificate" "cloudfront" {
  provider          = "aws.us-east-1"
  domain_name       = "mycode.rip"
  validation_method = "DNS"
}
