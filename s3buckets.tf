locals {
  bucket_basename = "${var.name_prefix}bucket-${var.aws_account_id}"
}

resource "aws_s3_bucket" "bucket1" {
  bucket = "${local.bucket_basename}-1"
  acl    = "private"
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "${local.bucket_basename}-2"
  acl    = "private"
}

resource "aws_s3_bucket_object" "testobj1" {
  bucket = "${local.bucket_basename}-1"
  key     = "testobj1"
  content = "Test data for object 1"
}

resource "aws_s3_bucket_object" "testobj2" {
  bucket = "${local.bucket_basename}-2"
  key     = "testobj2"
  content = "Test data for object 2"
}


output "bucket1" {
  value = aws_s3_bucket.bucket1.id
}

output "bucket2" {
  value = aws_s3_bucket.bucket2.id
}
