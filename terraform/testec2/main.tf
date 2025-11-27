variable "subnet_id" {
    description = "The ID of the public subnet where the EC2 instance will be launched"
    type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC"
    type        = string
}

variable "public_key" {
    description = "The public key to create the key pair"
    type        = string
}

provider "aws" {
    region = "us-east-1"
}

data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_key_pair" "ec2_key_pair" {
    key_name   = "ec2-key-pair"
    public_key = var.public_key
}

resource "aws_instance" "ec2_instance" {
    ami           = data.aws_ami.amazon_linux.id
    instance_type = "t2.micro"
    subnet_id     = var.subnet_id
    key_name      = aws_key_pair.ec2_key_pair.key_name

    tags = {
        Name = "TestEC2Instance"
    }

    associate_public_ip_address = true
}