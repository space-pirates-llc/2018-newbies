resource "aws_s3_bucket" "app-bucket" {
  bucket = "mf2018-app"
  acl    = "private"
}
