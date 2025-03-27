provider "aws" {
  region = "us-east-1"  # Primary region
}

provider "aws" {
  alias  = "secondary"
  region = "us-west-2"  # Secondary region
}

variable "vpc_id" {}
variable "primary_subnet_group" {
  type = string
}

variable "secondary_vpc_id" {}
variable "secondary_subnet_group" {
  type = string
}

variable "global_cluster_identifier" {
  description = "Identifier for the global cluster"
  type        = string
}

variable "primary_cluster_identifier" {
  description = "Identifier for the primary cluster"
  type        = string
}

variable "secondary_cluster_identifier" {
  description = "Identifier for the secondary cluster"
  type        = string
}

variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
}

variable "master_password" {
  description = "Master password for the database"
  type        = string
}

variable "primary_pg_sec_grp" {
  description = "Security group ID for the primary PostgreSQL cluster"
  type        = string
}

variable "secondary_pg_sec_grp" {
  description = "Security group ID for the secondary PostgreSQL cluster"
  type        = string
}

variable "parameter_group" {
  description = "Parameter group name for the PostgreSQL cluster"
  type        = string
}

variable "primary_instance_identifier" {
  description = "Identifier for the primary instance"
  type        = string
}

variable "secondary_instance_identifier" {
  description = "Identifier for the secondary instance"
  type        = string
}

variable "instance_class" {
  description = "Instance class for the PostgreSQL instances"
  type        = string
}

resource "aws_rds_global_cluster" "aurora_global" {
  global_cluster_identifier = var.global_cluster_identifier
  engine                   = "aurora-postgresql"
  engine_version           = "16.1"  // Updated to version 16.1
  storage_encrypted        = true
}

resource "aws_rds_cluster" "aurora_pg_primary" {
  depends_on               = [aws_rds_global_cluster.aurora_global]  # Ensures global cluster exists first
  global_cluster_identifier = aws_rds_global_cluster.aurora_global.id
  cluster_identifier        = var.primary_cluster_identifier
  engine                   = "aurora-postgresql"
  engine_version           = "16.1"  // Updated to version 16.1
  database_name            = var.database_name
  master_username          = var.master_username
  master_password          = var.master_password
  backup_retention_period  = 7
  preferred_backup_window  = "07:00-09:00"
  storage_encrypted        = true
  db_cluster_parameter_group_name = var.parameter_group
  vpc_security_group_ids   = [var.primary_pg_sec_grp]
  db_subnet_group_name     = var.primary_subnet_group
  skip_final_snapshot      = true
}

resource "aws_kms_key" "aurora_pg_secondary_kms_key" {
  provider = aws.secondary
  description = "KMS key for encrypting secondary Aurora PostgreSQL cluster"
  enable_key_rotation = true
}

resource "aws_rds_cluster" "aurora_pg_secondary" {
  provider                 = aws.secondary
  depends_on               = [aws_rds_cluster.aurora_pg_primary]  # Ensures primary cluster is created first
  global_cluster_identifier = aws_rds_global_cluster.aurora_global.id
  cluster_identifier       = var.secondary_cluster_identifier
  engine                   = "aurora-postgresql"
  engine_version           = "16.1"  // Updated to version 16.1
  storage_encrypted        = true
  kms_key_id               = aws_kms_key.aurora_pg_secondary_kms_key.arn
  db_subnet_group_name     = var.secondary_subnet_group
  vpc_security_group_ids   = [var.secondary_pg_sec_grp]
  db_cluster_parameter_group_name = var.parameter_group
  skip_final_snapshot      = true
}

resource "aws_rds_cluster_instance" "aurora_pg_primary_instance" {
  count              = 1  # Single instance for cost efficiency
  identifier         = var.primary_instance_identifier
  cluster_identifier = aws_rds_cluster.aurora_pg_primary.id
  instance_class     = var.instance_class
  engine            = aws_rds_cluster.aurora_pg_primary.engine
  engine_version    = aws_rds_cluster.aurora_pg_primary.engine_version
  publicly_accessible = false
}

# Add a cluster instance in the secondary region
resource "aws_rds_cluster_instance" "aurora_pg_secondary_instance" {
  provider          = aws.secondary
  count              = 1  # Single instance for cost efficiency
  identifier         = var.secondary_instance_identifier
  cluster_identifier = aws_rds_cluster.aurora_pg_secondary.id
  instance_class     = var.instance_class
  engine            = aws_rds_cluster.aurora_pg_secondary.engine
  engine_version    = aws_rds_cluster.aurora_pg_secondary.engine_version
  publicly_accessible = false
}

output "primary_cluster_endpoint" {
  description = "Endpoint for the primary Aurora PostgreSQL cluster"
  value       = aws_rds_cluster.aurora_pg_primary.endpoint
}

output "secondary_cluster_endpoint" {
  description = "Endpoint for the secondary Aurora PostgreSQL cluster"
  value       = aws_rds_cluster.aurora_pg_secondary.endpoint
}

output "global_cluster_id" {
  description = "ID of the Aurora Global Database"
  value       = aws_rds_global_cluster.aurora_global.id
}