variable "domain" {
  description = "Domain to verify with SES for email sending"
  type        = string
  default     = "hfu-amplify.org"
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID for DNS verification records"
  type        = string
}

variable "aws_region" {
  description = "AWS region where SES is configured (for MAIL FROM MX record)"
  type        = string
  default     = "us-east-1"
}

variable "enable_mail_from" {
  description = "Create a MAIL FROM subdomain for SPF alignment (improves deliverability)"
  type        = bool
  default     = true
}

variable "enable_configuration_set" {
  description = "Create an SES configuration set with reputation metrics enabled"
  type        = bool
  default     = true
}
