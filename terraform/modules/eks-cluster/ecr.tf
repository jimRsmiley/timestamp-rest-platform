resource "aws_ecr_repository" "timestamp-app" {
  name = "tf-${var.project_name}"

  image_scanning_configuration {
    scan_on_push = true
  }
}
