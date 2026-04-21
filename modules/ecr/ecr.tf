# TEMPORARILY using data source for pre-existing ECR repo
# After initial deploy, switch back to resource and import:
# terraform import module.ecr.aws_ecr_repository.app_repository prod-amplifygenai-repo
data "aws_ecr_repository" "existing" {
  name = var.ecr_repo_name
}

resource "aws_ecr_repository" "app_repository" {
  count                = 0  # Skip creation — repo already exists
  name                 = var.ecr_repo_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}
