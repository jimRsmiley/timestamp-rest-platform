variable "project_name" {
  type = string
}

variable "codebuild_source_s3_bucket_name" {
  type = string
}

variable "service_s3_deploy_conf_zip_key" {
  type        = string
  description = "The name of the zip file that will be uploaded to S3 and used by CodePipeline as the code source"
}
