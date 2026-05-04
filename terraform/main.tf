provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "DevOps-Pipeline"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "devops-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devops-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-public-subnet"
  }
}

# Data source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "devops-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "devops" {
  name        = "devops-sg"
  description = "Security group for DevOps application"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "devops-sg"
  }
}

# EC2 Instance
resource "aws_instance" "devops" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.devops.id]
  key_name               = var.key_pair_name

  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    docker_image = var.docker_image
  }))

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 50
    delete_on_termination = true
    encrypted             = true
  }

  monitoring    = true
  ebs_optimized = true

  tags = {
    Name = "devops-ec2"
  }

  depends_on = [aws_internet_gateway.main]
}

# Elastic IP
resource "aws_eip" "devops" {
  instance = aws_instance.devops.id
  domain   = "vpc"

  tags = {
    Name = "devops-eip"
  }

  depends_on = [aws_internet_gateway.main]
}

# Data source for Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "devops-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    InstanceId = aws_instance.devops.id
  }
}

# Outputs
output "ec2_public_ip" {
  value       = aws_eip.devops.public_ip
  description = "Public IP of EC2 instance"
}

output "ec2_instance_id" {
  value       = aws_instance.devops.id
  description = "EC2 instance ID"
}

output "security_group_id" {
  value       = aws_security_group.devops.id
  description = "Security group ID"
}
