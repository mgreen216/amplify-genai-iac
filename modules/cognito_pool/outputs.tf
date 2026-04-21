# Module now manages only the ACM certificate for auth.hfu-amplify.org.
# The live Cognito pool (us-east-1_PgwOR439P) is managed outside Terraform.
# See cognito_pool.tf for the 2026-04-21 consolidation note.

output "cognito_ssl_cert_arn" {
  description = "ARN of the ACM cert backing auth.hfu-amplify.org"
  value       = aws_acm_certificate.cognito_ssl_cert.arn
}
