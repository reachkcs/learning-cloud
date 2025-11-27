variable "region" {
  description = "AWS region for the logging bucket"
  type        = string
  default = "us-east-1"
}

variable "profile" {
  description = "AWS CLI/SDK profile name"
  type        = string
  default     = "LOGS"
}

variable "bucket_name" {
  description = "Name of the S3 bucket that will store NLB access logs"
  type        = string
  default     = "kcs-elb-access-logs"
}

variable "source_account_id" {
  description = "12‑digit Account A ID (the account that owns the NLB)"
  type        = string
  default = "677276112527"
}

variable "elb_account_id" {
  description = "ELB log‑delivery service account ID for the chosen region.  For us‑east‑1 this is 127311923021.  See AWS docs for your region."
  type        = string
  default     = "127311923021"
}