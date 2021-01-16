resource "aws_s3_bucket" "codepipeline_source" {
  bucket        = var.codebuild_source_s3_bucket_name
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket        = "tf-codepipeline-artifacts-${var.project_name}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}
