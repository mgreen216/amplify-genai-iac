variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, staging, prod)"
  type        = string
}

variable "alarm_email" {
  description = "Email address to receive alarm notifications"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster to monitor"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service to monitor"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB (the part after loadbalancer/)"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the target group"
  type        = string
}
