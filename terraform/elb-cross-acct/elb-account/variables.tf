variable "region" {
  description = "AWS region"
  type        = string
  default    = "us-east-1"
}

variable "profile" {
  description = "AWS CLI/SDK profile name"
  type        = string
  default     = "IBA"
}

variable "instance_type" {
  description = "EC2 instance type for Nginx instances"
  type        = string
  default     = "t3.micro"
}

variable "env" {
  description = "Environment tag"
  type        = string
  default     = "cicd"
}

# ---- Logging bucket details (from Account B) --------------------------------

variable "log_bucket" {
  description = "Name of the S3 bucket (in Account B) that will receive NLB access logs"
  type        = string
  default = "kcs-elb-access-logs"
}

variable "log_prefix" {
  description = "Prefix inside the bucket for NLB logs"
  type        = string
  default     = "nlb-access-logs"
}

variable "log_bucket_owner_account_id" {
  description = "12‑digit AWS Account ID that owns the log bucket (Account B)"
  type        = string
  default = "913524932740"
}