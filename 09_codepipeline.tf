#####################################
# S3 for CodePipeline Settings
#####################################
resource "aws_s3_bucket" "codepipeline" {
  bucket        = "mycode.rip-codepipeline"
  acl           = "private"
  force_destroy = true
}

#####################################
# CodeBuild Settings
#####################################
resource "aws_codebuild_project" "application" {
  name          = "mycode-rip-app"
  build_timeout = "10"
  service_role  = "${aws_iam_role.codebuild.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/nodejs:8.11.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }
}

#####################################
# CodePipeline Settings
#####################################
resource "aws_codepipeline" "application" {
  name     = "mycode-rip-app"
  role_arn = "${aws_iam_role.codepipeline.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipeline.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["app-source"]

      configuration {
        Owner                = "hareku"
        Repo                 = "mycode.rip"
        Branch               = "develop"
        PollForSourceChanges = "true"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["app-source"]

      configuration {
        ProjectName = "mycode-rip-app"
      }
    }
  }
}
