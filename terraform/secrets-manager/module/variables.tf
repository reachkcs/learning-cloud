variable "secret_name" {
  description = "The name of the secret"
  type        = string
}

variable "secret_value" {
  description = "The value of the secret (e.g., a private key)"
  type        = string
  sensitive   = true
}

variable "description" {
  description = "A description of the secret"
  type        = string
  default     = "Private key stored securely in Secrets Manager"
}

variable "tags" {
  description = "Tags to apply to the secret"
  type        = map(string)
  default     = {}
}

variable "kms_key_id" {
  description = "The ARN or ID of an existing KMS key to encrypt the secret"
  type        = string
}
