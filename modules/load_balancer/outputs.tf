# load_balancer/outputs.tf

output "load_balancer_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.tg.arn
}

output "alb_sg_id" {
  description = "The security group ID of the Application Load Balancer"
  value       = aws_security_group.alb_sg.id
}

output "alb_arn_suffix" {
  description = "The ARN suffix of the ALB for CloudWatch metrics"
  value       = aws_lb.alb.arn_suffix
}

output "target_group_arn_suffix" {
  description = "The ARN suffix of the target group for CloudWatch metrics"
  value       = aws_lb_target_group.tg.arn_suffix
}

output "ssl_certificate_arn" {
  description = "The ARN of the SSL certificate"
  value       = aws_acm_certificate.ssl_cert[0].arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private[*].id
}
