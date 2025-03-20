provider "aws" {
  region = "us-east-1"  # Primary region
}

provider "aws" {
  alias  = "secondary"
  region = "us-west-2"  # Secondary region
}

variable "primary_subnet_ids" {
  type = list(string)
}

variable "secondary_subnet_ids" {
  type = list(string)
}

resource "aws_db_subnet_group" "primary_subnet_group" {
  name        = "primary-subnet-group"
  subnet_ids  = var.primary_subnet_ids
  description = "Subnet group for primary resources"
}

resource "aws_db_subnet_group" "secondary_subnet_group" {
  provider    = aws.secondary
  name        = "secondary-subnet-group"
  subnet_ids  = var.secondary_subnet_ids
  description = "Subnet group for secondary resources"
}