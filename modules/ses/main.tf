###############################################################################
# SES – Domain identity, DKIM, MAIL FROM, and noreply email for Cognito
###############################################################################

# ---------- Domain Identity ----------

resource "aws_ses_domain_identity" "this" {
  domain = var.domain
}

# ---------- DKIM ----------

resource "aws_ses_domain_dkim" "this" {
  domain = aws_ses_domain_identity.this.domain
}

resource "aws_route53_record" "dkim" {
  count   = 3
  zone_id = var.route53_zone_id
  name    = "${aws_ses_domain_dkim.this.dkim_tokens[count.index]}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["${aws_ses_domain_dkim.this.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

# ---------- MAIL FROM domain (SPF alignment) ----------

resource "aws_ses_domain_mail_from" "this" {
  count                  = var.enable_mail_from ? 1 : 0
  domain                 = aws_ses_domain_identity.this.domain
  mail_from_domain       = "mail.${var.domain}"
  behavior_on_mx_failure = "UseDefaultValue"
}

resource "aws_route53_record" "mail_from_mx" {
  count   = var.enable_mail_from ? 1 : 0
  zone_id = var.route53_zone_id
  name    = "mail.${var.domain}"
  type    = "MX"
  ttl     = 600
  records = ["10 feedback-smtp.${var.aws_region}.amazonses.com"]
}

resource "aws_route53_record" "mail_from_spf" {
  count   = var.enable_mail_from ? 1 : 0
  zone_id = var.route53_zone_id
  name    = "mail.${var.domain}"
  type    = "TXT"
  ttl     = 600
  records = ["v=spf1 include:amazonses.com -all"]
}

# ---------- Configuration Set (bounce / complaint tracking) ----------

resource "aws_ses_configuration_set" "this" {
  count = var.enable_configuration_set ? 1 : 0
  name  = "${replace(var.domain, ".", "-")}-config"

  reputation_metrics_enabled = true
  sending_enabled            = true
}

# ---------- Noreply Email Identity ----------

resource "aws_ses_email_identity" "noreply" {
  email = "noreply@${var.domain}"
}

# ---------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------

output "domain_identity_arn" {
  description = "ARN of the SES domain identity (for Cognito email_configuration)"
  value       = aws_ses_domain_identity.this.arn
}

output "configuration_set_name" {
  description = "Name of the SES configuration set, if enabled"
  value       = var.enable_configuration_set ? aws_ses_configuration_set.this[0].name : null
}

output "mail_from_domain" {
  description = "The MAIL FROM subdomain, if enabled"
  value       = var.enable_mail_from ? aws_ses_domain_mail_from.this[0].mail_from_domain : null
}
