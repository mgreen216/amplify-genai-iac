# After the 2026-04-21 consolidation, this module only manages the ACM cert
# for auth.hfu-amplify.org. All Cognito pool / client / SAML / SSO variables
# were removed — the live pool (us-east-1_PgwOR439P) is managed outside
# Terraform.

variable "cognito_domain" {
  description = "FQDN of the Cognito custom domain (e.g. auth.hfu-amplify.org)"
  type        = string
}

variable "cognito_route53_zone_id" {
  description = "Route53 hosted zone ID for the cert validation CNAME"
  type        = string
}
