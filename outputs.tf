output "ec2_instance_id" {
  description = "The ID of the deployed EC2 instance."
  value       = aws_instance.web_server.id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance (if assigned)."
  value       = aws_instance.web_server.public_ip
}

output "ec2_public_dns" {
  description = "The public DNS name of the EC2 instance (if assigned)."
  value       = aws_instance.web_server.public_dns
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 Security Group."
  value       = aws_security_group.ec2_security_group.id
}

output "cloudwatch_alarm_arn" {
  description = "The ARN of the CloudWatch CPU utilisation alarm."
  value       = aws_cloudwatch_metric_alarm.cpu_utilisation_alarm.arn
}
