terraform {
  backend "s3" {
    bucket = "mycode.rip-terraform-state"
    key    = "mycode-rip"
    region = "ap-northeast-1"
  }
}
