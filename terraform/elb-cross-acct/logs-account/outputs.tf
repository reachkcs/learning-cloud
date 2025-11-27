output "bucket_name" {
  value       = aws_s3_bucket.nlb_logs.id
  description = "S3 bucket that stores NLB access logs"
}

output "bucket_arn" {
  value       = aws_s3_bucket.nlb_logs.arn
  description = "ARN of the logging bucket"
}