provider "aws" {
  region = "us-east-1"  # Primary region
}

provider "aws" {
  alias  = "secondary"
  region = "us-west-2"  # Secondary region
}

variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}
variable "secondary_vpc_id" {}
variable "secondary_subnet_ids" {
  type = list(string)
}

variable "public_subnet_id" {
  description = "ID of the public subnet for the EC2 instance"
  type        = string
}

resource "aws_rds_cluster_parameter_group" "aurora_pg_param_group" {
  name        = "aurora-pg-param-group"
  family      = "aurora-postgresql15"
  description = "Aurora PostgreSQL cluster parameter group"

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }
}

resource "aws_rds_global_cluster" "aurora_global" {
  global_cluster_identifier = "aurora-pg-global-cluster"
  engine                   = "aurora-postgresql"
  engine_version           = "15.3"
  storage_encrypted        = true
}

resource "aws_rds_cluster" "aurora_pg_primary" {
  depends_on               = [aws_rds_global_cluster.aurora_global]  # Ensures global cluster exists first
  global_cluster_identifier = aws_rds_global_cluster.aurora_global.id
  cluster_identifier        = "aurora-pg-cluster-primary"
  engine                   = "aurora-postgresql"
  engine_version           = "15.3"
  database_name            = "mydatabase"
  master_username          = "aurora_admin"
  master_password          = "SuperSecurePass123"
  backup_retention_period  = 7
  preferred_backup_window  = "07:00-09:00"
  storage_encrypted        = true
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_pg_param_group.name
  vpc_security_group_ids   = [aws_security_group.aurora_sg.id]
  db_subnet_group_name     = aws_db_subnet_group.aurora_pg_subnet_group.name
  skip_final_snapshot      = true
}

resource "aws_rds_cluster" "aurora_pg_secondary" {
  provider                 = aws.secondary
  depends_on               = [aws_rds_cluster.aurora_pg_primary]  # Ensures primary cluster is created first
  global_cluster_identifier = aws_rds_global_cluster.aurora_global.id
  cluster_identifier       = "aurora-pg-cluster-secondary"
  engine                   = "aurora-postgresql"
  engine_version           = "15.3"
  storage_encrypted        = true
  kms_key_id               = aws_kms_key.secondary_kms_key.arn  # Reference the new KMS key
  db_subnet_group_name     = aws_db_subnet_group.aurora_pg_secondary_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.aurora_sg_secondary.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_pg_param_group_secondary.name
  skip_final_snapshot      = true
}

# Secondary region parameter group
resource "aws_rds_cluster_parameter_group" "aurora_pg_param_group_secondary" {
  provider    = aws.secondary  # Use the secondary provider
  name        = "aurora-pg-param-group-secondary"
  family      = "aurora-postgresql15"
  description = "Aurora PostgreSQL cluster parameter group for secondary"

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }
}

resource "aws_rds_cluster_instance" "aurora_pg_primary_instance" {
  count              = 1  # Single instance for cost efficiency
  identifier         = "aurora-pg-instance-primary"
  cluster_identifier = aws_rds_cluster.aurora_pg_primary.id
  instance_class     = "db.r5.large"
  engine            = aws_rds_cluster.aurora_pg_primary.engine
  engine_version    = aws_rds_cluster.aurora_pg_primary.engine_version
  publicly_accessible = false
}

# Add a cluster instance in the secondary region
resource "aws_rds_cluster_instance" "aurora_pg_secondary_instance" {
  provider          = aws.secondary
  count              = 1  # Single instance for cost efficiency
  identifier         = "aurora-pg-instance-secondary"
  cluster_identifier = aws_rds_cluster.aurora_pg_secondary.id
  instance_class     = "db.r5.large"
  engine            = aws_rds_cluster.aurora_pg_secondary.engine
  engine_version    = aws_rds_cluster.aurora_pg_secondary.engine_version
  publicly_accessible = false
}

resource "aws_kms_key" "secondary_kms_key" {
  provider = aws.secondary
  description = "KMS key for encrypting secondary Aurora PostgreSQL cluster"
  enable_key_rotation = true
}

resource "aws_db_subnet_group" "aurora_pg_subnet_group" {
  name        = "aurora-pg-subnet-group"
  subnet_ids  = var.subnet_ids
  description = "Subnet group for Aurora PostgreSQL Primary"
}

resource "aws_db_subnet_group" "aurora_pg_secondary_subnet_group" {
  provider    = aws.secondary
  name        = "aurora-pg-secondary-subnet-group"
  subnet_ids  = var.secondary_subnet_ids
  description = "Subnet group for Aurora PostgreSQL Secondary"
}

resource "aws_security_group" "aurora_sg" {
  name_prefix = "aurora-pg-sg"
  description = "Allow inbound PostgreSQL access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "aurora_sg_secondary" {
  provider    = aws.secondary
  name_prefix = "aurora-pg-sg-secondary"
  description = "Allow inbound PostgreSQL access in secondary region"
  vpc_id      = var.secondary_vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Restrict this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2
# Create a key pair for EC2 instance
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXQeWsmLzfgpJgwjG77OtlElm//t5CAlehHlQmReIEZRFe0tFhHBnsZSWEau5hVCKhnN8hKhNWr+Nikk4Q1EeUMwdOAPom833+NRlgZN+yeFcIx2jB2WYwCLLFoxHWk0NWIHE8mTkYlK3BiloCJg0DO9gnayzIfBmkVgDelAUJSiFBessvEeMw0l6V/S5jgVF7AEwTcFYUOicViyQkEkxWyaP8x0VE6UBw/lR5Y0TiG/ST3wj77TwcuPfYW7Exg21a4PW/mEqw6f4kHTAnDGGGzjWIBdfAWz9edpTeiZX5cvIJIALnBqNFkotBKBQrkQnmESzHhI8vzseQA6EB1vVx schidambaram@Sreedhars-MacBook-Pro.local"
}

# Create security group for EC2 instance
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  # Allow SSH access from specific IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["70.106.201.186/32"]
  }

  # Allow PostgreSQL access from EC2 to Aurora
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.aurora_sg.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Update the security group in the secondary region to allow access from the primary region EC2
#resource "aws_security_group_rule" "allow_ec2_to_secondary_aurora" {
#  provider          = aws.secondary
#  type              = "ingress"
#  from_port         = 5432
#  to_port           = 5432
#  protocol          = "tcp"
#  cidr_blocks       = ["0.0.0.0/0"]  # In production, use the EC2 instance's public IP
#  security_group_id = aws_security_group.aurora_sg_secondary.id
#  description       = "Allow PostgreSQL access from primary region EC2 instance"
#}

#
# Create EC2 instance in the public subnet
#
# Get the latest Amazon Linux 2023 AMI from SSM Parameter Store
data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "db_management_instance" {
  #ami                    = "ami-0230bd60aa48260c6" # Amazon Linux 2023 in us-east-1
  ami                         = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.ec2_key_pair.key_name
  associate_public_ip_address = true
  user_data = <<-EOF
    # Install required packages
    sudo yum install -y postgresql16-16.8-1.amzn2023.0.1.x86_64
    sudo yum install -y postgresql16-contrib-16.8-1.amzn2023.0.1.x86_64
    sudo yum install -y git-2.47.1-1.amzn2023.0.2.x86_64

    # Configure .bashrc for PG connectivity
    echo '# Postgres details' >> ~ec2-user/.bashrc
    echo 'export PGHOST=<primary cluster end point>' >> ~ec2-user/.bashrc
    echo 'export PGUSER=aurora_admin' >> ~ec2-user/.bashrc
    echo 'export PGPASSWORD=SuperSecurePass123' >> ~ec2-user/.bashrc
    echo 'export PGDATABASE=mydatabase' >> ~ec2-user/.bashrc
    echo 'export PGPORT=5432' >> ~ec2-user/.bashrc

    # Set up PG Bench with sample data
    createdb pgbench_test
    pgbench -i -s 10 pgbench_test
    psql -d pgbench_test -c "\dt"
    # Command to run perf test
    # pgbench -c 10 -j 2 -T 60 pgbench_test
    # -c 10 → 10 concurrent clients
    # -j 2 → 2 worker threads
    # -T 60 → Run the test for 60 seconds

    # Setup Northwind database
    # Download Northwind database
    git clone https://github.com/pthom/northwind_psql.git
    cd northwind_psql
    createdb northwind
    psql -d northwind -f northwind.sql
    psql -d northwind -c "\dt"

    # Setup DVDRental sample data
    mkdir dvdrental
    cd dvdrental
    wget https://neon.tech/postgresqltutorial/dvdrental.zip
    unzip dvdrental.zip 
    createdb dvdrental
    pg_restore -U aurora_admin -d dvdrental dvdrental.tar
    psql -d dvdrental -c "\dt"
  EOF

  tags = {
    Name = "aurora-db-management-instance"
  }
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

output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.db_management_instance.public_ip
}

output "ec2_instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.db_management_instance.public_dns
}