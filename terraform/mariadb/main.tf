#terraform init 
#terraform plan
#terraform apply -auto-approve 
#terraform output ec2_public_ip
#mysql -h <ec2-public-ip> -u anukcs -p kcsdb

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "mariadb_sg" {
  name        = "mariadb_sg"
  description = "Allow SSH and MariaDB access"

  # Allow SSH (Port 22) for remote access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["70.106.201.186/32"]
  }

  # Allow MySQL/MariaDB (Port 3306)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["70.106.201.186/32"] 
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an AWS key pair using the provided public key
resource "aws_key_pair" "mariadb_key" {
  key_name   = "mariadb-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXQeWsmLzfgpJgwjG77OtlElm//t5CAlehHlQmReIEZRFe0tFhHBnsZSWEau5hVCKhnN8hKhNWr+Nikk4Q1EeUMwdOAPom833+NRlgZN+yeFcIx2jB2WYwCLLFoxHWk0NWIHE8mTkYlK3BiloCJg0DO9gnayzIfBmkVgDelAUJSiFBessvEeMw0l6V/S5jgVF7AEwTcFYUOicViyQkEkxWyaP8x0VE6UBw/lR5Y0TiG/ST3wj77TwcuPfYW7Exg21a4PW/mEqw6f4kHTAnDGGGzjWIBdfAWz9edpTeiZX5cvIJIALnBqNFkotBKBQrkQnmESzHhI8vzseQA6EB1vVx schidambaram@Sreedhars-MacBook-Pro.local"
}

resource "aws_instance" "mariadb_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Choose an appropriate size
  key_name      = aws_key_pair.mariadb_key.key_name
  vpc_security_group_ids = [aws_security_group.mariadb_sg.id]
  subnet_id = "subnet-06afee81c2a516bc6"
  associate_public_ip_address = true

  user_data = <<-EOF
    sudo dnf install -y dnf-utils
    echo '[mariadb]' > /etc/yum.repos.d/mariadb.repo
    echo 'name = MariaDB' >> /etc/yum.repos.d/mariadb.repo
    echo 'baseurl = https://rpm.mariadb.org/10.11/rhel/9/x86_64/' >> /etc/yum.repos.d/mariadb.repo
    echo 'gpgkey = https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB' >> /etc/yum.repos.d/mariadb.repo
    echo 'gpgcheck = 1' >> /etc/yum.repos.d/mariadb.repo
    echo 'enabled = 1' >> /etc/yum.repos.d/mariadb.repo
    echo 'module_hotfixes = 1' >> /etc/yum.repos.d/mariadb.repo
    sudo rpm --import https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB
    sudo dnf clean all
    sudo dnf makecache
    sudo dnf install MariaDB-server MariaDB-client -y

    sudo systemctl start mariadb
    sudo systemctl enable mariadb

    # Secure MariaDB setup
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'abcd1234'; FLUSH PRIVILEGES;"

    # Create database and user
    mysql -u root -pabcd1234 -e "CREATE DATABASE kcsdb;"
    mysql -u root -pabcd1234 -e "CREATE USER 'anukcs'@'%' IDENTIFIED BY 'abcd1234';"
    mysql -u root -pabcd1234 -e "GRANT ALL PRIVILEGES ON kcsdb.* TO 'anukcs'@'%'; FLUSH PRIVILEGES;"

    # Configure remote access
    sudo sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/my.cnf
    sudo systemctl restart mariadb
  EOF

  tags = {
    Name = "MariaDB-EC2"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-*-x86_64"]
  }
}

output "ec2_public_ip" {
  description = "Public IP of the MariaDB EC2 instance"
  value       = aws_instance.mariadb_ec2.public_ip
}
