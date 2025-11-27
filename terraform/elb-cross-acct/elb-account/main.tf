###############################################################################
# NETWORK & SECURITY
###############################################################################

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public_one_per_az" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "tag:Name"
    values = ["public"]
  }
}

# Pick first 2 public subnets across distinct AZs
locals {
  public_subnets = distinct(data.aws_subnets.public_one_per_az.ids)
  selected_subnets = slice(local.public_subnets, 0, 2)
}

resource "aws_security_group" "nginx" {
  name_prefix = "nlb-nginx-"
  description = "Allow HTTP from anywhere (you may want to lock this down)"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Latest AL2023 AMI

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "nginx" {
  count         = local.instance_count
  ami           = data.aws_ami.al2023.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.nginx.id]
  subnet_id              = element(data.aws_subnets.public_one_per_az.ids, count.index)
  associate_public_ip_address = true

  # Installs & starts nginx
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install -y nginx1
              systemctl enable nginx && systemctl start nginx
              echo "Hello from nginx-${count.index}" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = format("nginx-%02d", count.index + 1)
    Env  = var.env
  }
}

###############################################################################
# NETWORK LOAD BALANCER
###############################################################################

resource "aws_lb" "nlb" {
  name               = "nginx-nlb"
  load_balancer_type = "network"
  subnets = local.selected_subnets
  enable_cross_zone_load_balancing = true

  access_logs {
    bucket                  = var.log_bucket
    prefix                  = var.log_prefix
    enabled                 = true
    #bucket_owner_account_id = var.log_bucket_owner_account_id
  }

  tags = {
    Name = "nginx-nlb"
    Env  = var.env
  }
}

resource "aws_lb_target_group" "nginx" {
  name        = "nginx-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    protocol = "TCP"
    port     = "80"
  }
}

resource "aws_lb_listener" "tcp_80" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

# Attach both instances to the TG
resource "aws_lb_target_group_attachment" "this" {
  count            = local.instance_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = element(aws_instance.nginx.*.id, count.index)
  port             = 80
}