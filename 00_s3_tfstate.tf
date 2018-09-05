resource "aws_s3_bucket" "terraform_state" {
  bucket = "mycode.rip-terraform-state"
  acl    = "private"
}
