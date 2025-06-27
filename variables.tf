variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "The type of EC2 instance to launch (e.g., t2.micro, t3.micro)."
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance (e.g., Amazon Linux 2 AMI)."
  type        = string
  default = "ami-0eb260c65066dc10c"
}

variable "key_pair_name" {
  description = "The name of an existing EC2 Key Pair for SSH access."
  type        = string
  default = "my-ec2-key"
}

variable "cloudwatch_alarm_cpu_threshold" {
  description = "The CPU utilisation percentage threshold for the CloudWatch alarm."
  type        = number
  default     = 80
}
