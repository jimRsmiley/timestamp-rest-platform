resource "aws_iam_role" "codebuild" {
  name = "tf-codebuild-${var.project_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild" {
  role = aws_iam_role.codebuild.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:ListTagsForResource",
          "ecr:DescribeImageScanFindings",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.codepipeline_artifacts.arn}",
        "${aws_s3_bucket.codepipeline_artifacts.arn}/*",
        "${aws_s3_bucket.codepipeline_source.arn}",
        "${aws_s3_bucket.codepipeline_source.arn}/*"
      ],
      "Action": [
        "s3:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "${aws_ecr_repository.default.arn}"
      ],
      "Action": [
        "ecr:*"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "ecr:GetAuthorizationToken"
      ]
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "default" {
  name          = "tf-${var.project_name}"
  description   = "CodeBuild project for ${var.project_name}"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  source {
    type = "CODEPIPELINE"

    buildspec = "buildspec.yml"
  }
}
