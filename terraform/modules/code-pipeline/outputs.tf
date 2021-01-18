output "codepipeline_source_bucket_id" {
  value = aws_s3_bucket.codepipeline_source.id
}

# output "codepipeline_id" {
#   value = aws_codepipeline.default.id
# }
