#####################################
# IAM Settings
#####################################
# CodePipeline
data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "AWSCodePipelineRole-For-mycode.rip"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline_assume_role.json}"
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    actions = [
      "*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "codepipeline" {
  name   = "CodePipelinePolicy-For-mycode.rip"
  path   = "/"
  policy = "${data.aws_iam_policy_document.codepipeline.json}"
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = "${aws_iam_role.codepipeline.name}"
  policy_arn = "${aws_iam_policy.codepipeline.arn}"
}

# CodeBuild
data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "AWSCodeBuildRole-For-mycode.rip"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild_assume_role.json}"
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    actions = [
      "s3:*",
      "logs:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "codebuild" {
  name   = "CodeBuildPolicy-For-mycode.rip"
  path   = "/"
  policy = "${data.aws_iam_policy_document.codebuild.json}"
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = "${aws_iam_role.codebuild.name}"
  policy_arn = "${aws_iam_policy.codebuild.arn}"
}

# Lambda@Edge
data "aws_iam_policy_document" "lambda_edge_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_edge" {
  name               = "AWSLambdaEdgeRole-For-mycode.rip"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_edge_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_edge_basic_execution" {
  role       = "${aws_iam_role.lambda_edge.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# API Gateway
data "aws_iam_policy_document" "api_gateway_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api_gateway" {
  name               = "AWSAPIGatewayRole-For-mycode.rip"
  assume_role_policy = "${data.aws_iam_policy_document.api_gateway_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "api_gateway_lambda" {
  role       = "${aws_iam_role.api_gateway.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

# Lambda for CodePipeline execution
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_codepipeline_execution" {
  name               = "AWSLambdaCodePipelineExecutionRole-For-mycode.rip"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role.json}"
}

data "aws_iam_policy_document" "lambda_codepipeline_execution" {
  statement {
    actions = [
      "apigateway:*",
      "codepipeline:*",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_policy" "lambda_codepipeline_execution" {
  name   = "LambdaCodePipelineExecutionPolicy-For-mycode.rip"
  path   = "/"
  policy = "${data.aws_iam_policy_document.lambda_codepipeline_execution.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_codepipeline_execution" {
  role       = "${aws_iam_role.lambda_codepipeline_execution.name}"
  policy_arn = "${aws_iam_policy.lambda_codepipeline_execution.arn}"
}
