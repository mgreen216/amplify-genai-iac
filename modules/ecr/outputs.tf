output "ecr_image_repository_url" {
  value = data.aws_ecr_repository.existing.repository_url
}

output "ecr_image_repository_arn" {
  value = data.aws_ecr_repository.existing.arn
}

output "ecr_image_repository_name" {
  value = data.aws_ecr_repository.existing.name
}
