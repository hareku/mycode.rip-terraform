#####################################
# Route53 Settings
#####################################
resource "aws_route53_zone" "this" {
  name = "mycode.rip"
}

resource "aws_route53_record" "this" {
  zone_id = "${aws_route53_zone.this.zone_id}"
  name    = "mycode.rip"
  type    = "A"

  alias {
    name                   = "${aws_cloudfront_distribution.this.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.this.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "acm" {
  zone_id = "${aws_route53_zone.this.zone_id}"
  name    = "_cea5edc985c105e7d957c00ef484ff0e.mycode.rip."
  type    = "CNAME"
  ttl     = "300"
  records = ["_b6073db9c0c4de771e725f92e02ef632.tljzshvwok.acm-validations.aws."]
}
