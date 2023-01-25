resource "aws_s3_bucket" "s3_northwindo" {
  bucket = "dadonorthwindo"
  tags = {
    Name = "Bucket com os Dados Northwindo"
  }
}

resource "aws_s3_bucket_acl" "acl_bucket_northwindo" {
  bucket = aws_s3_bucket.s3_northwindo.id
  acl    = "private"
}