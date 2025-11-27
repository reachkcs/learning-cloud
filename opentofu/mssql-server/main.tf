provider "aws" {
  region = "us-east-1" # Change as needed
}

resource "aws_db_subnet_group" "mssql_subnet_group" {
  name       = "mssql-subnet-group"
  subnet_ids = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"] # Replace with your subnet IDs

  tags = {
    Name = "mssql-subnet-group"
  }
}

resource "aws_security_group" "mssql_sg" {
  name        = "mssql-sg"
  description = "Allow SQL Server access"
  vpc_id      = "vpc-xxxxxxxx" # Replace with your VPC ID

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP/32"] # Replace with your IP or allowed CIDR range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mssql-sg"
  }
}

resource "aws_db_instance" "mssql_rds" {
  identifier             = "mssql-std-db"
  engine                 = "sqlserver-se"
  engine_version         = "15.00.4430.1.v1"
  instance_class         = "db.m5.large"
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp2"
  username               = "adminuser"
  password               = "StrongP@ssw0rd123!" # Consider using secrets manager
  db_subnet_group_name   = aws_db_subnet_group.mssql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.mssql_sg.id]
  publicly_accessible    = false
  multi_az               = false
  license_model          = "license-included"
  backup_retention_period = 7
  skip_final_snapshot     = true

  tags = {
    Name = "mssql-std-db"
  }
}

