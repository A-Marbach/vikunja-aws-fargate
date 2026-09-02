resource "aws_s3_bucket" "vikunja_files" {
  bucket_prefix = "${var.project_name}-files-"

  tags = {
    Name    = "${var.project_name}-files"
    Project = var.project_name
  }
}

resource "aws_s3_bucket_public_access_block" "vikunja_files" {
  bucket = aws_s3_bucket.vikunja_files.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vikunja_files" {
  bucket = aws_s3_bucket.vikunja_files.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
