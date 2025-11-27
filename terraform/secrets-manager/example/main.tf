provider "aws" {
  region = "us-east-1"
}

module "private_key_secret" {
  source       = "../modules/secrets_manager"
  secret_name  = "my-private-key"
  secret_value = file("${path.module}/private_key.pem")
  description  = "RSA private key for my app"
  kms_key_id   = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-abcd-5678-efgh-9876543210ef"
  tags = {
    environment = "dev"
    project     = "key-management"
  }
}
