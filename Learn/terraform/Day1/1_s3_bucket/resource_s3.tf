resource "aws_s3_bucket" "mybucket" {
  bucket = "my-first-acc-sr-bucket"
  acl    = "private"
}

