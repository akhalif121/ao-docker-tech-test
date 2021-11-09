resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "ao-mm-bucket"
  acl    = "private"
}
