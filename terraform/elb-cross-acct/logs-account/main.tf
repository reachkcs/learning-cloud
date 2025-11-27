resource "aws_s3_bucket" "nlb_logs" {
  bucket = var.bucket_name
  # Feel free to turn this on if you want automatic cleanup later
  force_destroy = false
  tags = {
    Purpose = "NLB access logs"
  }
}

resource "aws_s3_bucket_versioning" "nlb_logs" {
  bucket = aws_s3_bucket.nlb_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.nlb_logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# --- Bucket Policy ----------------------------------------------------------
# Allows the ELB service principal for your *region* to PUT, and allows the
# source account (Account A) to read its own logs if desired.
# ---------------------------------------------------------------------------

data "aws_iam_policy_document" "nlb_logs" {
  statement {
    sid    = "AllowELBLogDelivery"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.elb_account_id}:root"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.nlb_logs.arn}/AWSLogs/${var.source_account_id}/*"]

    #condition {
      #test     = "StringEquals"
      #variable = "s3:x-amz-acl"
      #values   = ["bucket-owner-full-control"]
    #}
  }

  statement {
    sid    = "AllowSourceAccountRead"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.source_account_id}:root"]
    }

    actions   = ["s3:GetBucketAcl", "s3:ListBucket", "s3:GetObject"]
    resources = [aws_s3_bucket.nlb_logs.arn, "${aws_s3_bucket.nlb_logs.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "nlb_logs" {
  bucket = aws_s3_bucket.nlb_logs.id
  policy = data.aws_iam_policy_document.nlb_logs.json
}