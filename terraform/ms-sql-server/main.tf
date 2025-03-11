provider "aws" {
  region = "us-east-1"  # Adjust as needed
}

resource "aws_key_pair" "deployer" {
  key_name   = "sqlserver-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXQeWsmLzfgpJgwjG77OtlElm//t5CAlehHlQmReIEZRFe0tFhHBnsZSWEau5hVCKhnN8hKhNWr+Nikk4Q1EeUMwdOAPom833+NRlgZN+yeFcIx2jB2WYwCLLFoxHWk0NWIHE8mTkYlK3BiloCJg0DO9gnayzIfBmkVgDelAUJSiFBessvEeMw0l6V/S5jgVF7AEwTcFYUOicViyQkEkxWyaP8x0VE6UBw/lR5Y0TiG/ST3wj77TwcuPfYW7Exg21a4PW/mEqw6f4kHTAnDGGGzjWIBdfAWz9edpTeiZX5cvIJIALnBqNFkotBKBQrkQnmESzHhI8vzseQA6EB1vVx schidambaram@Sreedhars-MacBook-Pro.local"
}

resource "aws_security_group" "sqlserver_sg" {
  name        = "sqlserver-sg"
  description = "Allow RDP and SQL Server access"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world for RDP
  }

  ingress {
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to the world for SQL Server
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sqlserver" {
  ami           = "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.sqlserver_sg.name]

  tags = {
    Name = "SQLServerExpressInstance"
  }
}

output "sqlserver_public_ip" {
  value = aws_instance.sqlserver.public_ip
}