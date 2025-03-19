resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  
  tags = {
    Environment = var.environment
    Managed_by  = "Terragrunt"
  }
}