#####################################
# S3 Bucket Settings
#####################################
resource "aws_s3_bucket" "this" {
  bucket        = "mycode.rip"
  acl           = "private"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  lifecycle_rule {
    id      = "delete-old-version"
    enabled = true

    tags = {
      ShouldDelete = 1
    }

    expiration {
      days = 2
    }
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid       = "PublicReadForGetBucketObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.this.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "${aws_s3_bucket.this.id}"
  policy = "${data.aws_iam_policy_document.s3.json}"
}
