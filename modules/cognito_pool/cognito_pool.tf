# -----------------------------------------------------------------------------
# NOTE (2026-04-21): This module used to manage a full Cognito user pool for
# Amplify. The production pool has since been consolidated onto the live pool
# `us-east-1_PgwOR439P` (name: prod-amplify-users), which is NOT managed by
# Terraform — it pre-dates IaC and holds the real user population.
#
# What this module still manages:
#   - ACM certificate for `auth.hfu-amplify.org`
#   - ACM cert DNS validation record
#
# What was removed:
#   - aws_cognito_user_pool / client / domain / SAML IdP  → deleted in AWS
#   - aws_route53_record.cognito_auth_custom_domain        → now points at the
#     live pool's CloudFront distribution; managed outside Terraform for now.
#   - preAuthLambda resources                              → never applied.
# -----------------------------------------------------------------------------

resource "aws_acm_certificate" "cognito_ssl_cert" {
  domain_name       = var.cognito_domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cognito_ssl_cert_validation" {
  certificate_arn         = aws_acm_certificate.cognito_ssl_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cognito_cert_validation : record.fqdn]
}

locals {
  cognito_cert_validation_records = {
    for dvo in aws_acm_certificate.cognito_ssl_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }
}

resource "aws_route53_record" "cognito_cert_validation" {
  for_each = local.cognito_cert_validation_records

  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  zone_id         = var.cognito_route53_zone_id
  records         = [each.value.record]
  ttl             = 60
}
