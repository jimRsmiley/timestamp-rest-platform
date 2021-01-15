locals {
  zipfile_path       = "../tmp/timestamp-app.zip"
  source_dir         = "../node-app"
  zipfile_object_key = "timestamp-app.zip"
}

data "archive_file" "codepipeline_source" {

  type        = "zip"
  output_path = local.zipfile_path
  source_dir  = local.source_dir
}

resource "aws_s3_bucket_object" "codepipeline_source" {

  bucket = var.bucket_id

  key    = local.zipfile_object_key
  acl    = "private" # or can be "public-read"
  source = local.zipfile_path
  etag   = filemd5(local.zipfile_path)

  depends_on = [data.archive_file.codepipeline_source]
}
