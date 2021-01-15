locals {
  zipfile_path       = "./timestamp-app.zip"
  source_dir         = "../node-app"
  zipfile_object_key = "timestamp-app.zip"
}

data "archive_file" "codepipeline_source" {
  type        = "zip"
  source_dir  = local.source_dir
  output_path = local.zipfile_path
}

resource "aws_s3_bucket_object" "codepipeline_source" {

  bucket = var.bucket_id

  key    = local.zipfile_object_key
  acl    = "private" # or can be "public-read"
  source = data.archive_file.codepipeline_source.output_path
  etag   = filemd5(data.archive_file.codepipeline_source.output_path)
}
