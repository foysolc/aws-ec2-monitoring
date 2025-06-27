# --- AWS Provider Configuration ---
provider "aws" {
  region = var.aws_region
}

# --- Data Source: Retrieve Default VPC (or a specific existing VPC) ---
data "aws_vpc" "selected" {
  default = true
}

# --- Data Source: Find latest Amazon Linux 2 AMI ---
data "aws_ami" "amazon_linux_2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# --- EC2 Security Group: Firewall Rules for EC2 Instance ---
resource "aws_security_group" "ec2_security_group" {
  name        = "${var.key_pair_name}-ec2-sg"
  description = "Allow SSH, HTTP, HTTPS access to EC2 instance"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
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
    Name    = "${var.key_pair_name}-ec2-sg"
    Project = "EC2Monitoring"
  }
}

# --- EC2 Instance: Your Virtual Server ---
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from your Terraform-deployed EC2 instance!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name    = "${var.key_pair_name}-web-server"
    Project = "EC2Monitoring"
  }
}

# --- CloudWatch Metric Alarm: CPU Utilisation ---
resource "aws_cloudwatch_metric_alarm" "cpu_utilisation_alarm" {
  alarm_name          = "${var.key_pair_name}-high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cloudwatch_alarm_cpu_threshold
  alarm_description   = "This alarm monitors EC2 CPU utilisation"
  treat_missing_data  = "notBreaching"

  dimensions = {
    InstanceId = aws_instance.web_server.id
  }

  tags = {
    Project = "EC2Monitoring"
  }
}
