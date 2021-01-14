resource "aws_ecr_repository" "default" {
  name = "tf-${var.project_name}-0"

  image_scanning_configuration {
    scan_on_push = true
  }
}
