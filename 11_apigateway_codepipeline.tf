#####################################
# API Gateway Settings
#####################################
resource "aws_api_gateway_rest_api" "codepipeline_execution" {
  name = "CodePipelineExecutionAPI-For-mycode.rip"
}

resource "aws_api_gateway_resource" "codepipeline_execution" {
  path_part   = "execute"
  parent_id   = "${aws_api_gateway_rest_api.codepipeline_execution.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.codepipeline_execution.id}"
}

resource "aws_api_gateway_method" "codepipeline_execution" {
  rest_api_id      = "${aws_api_gateway_rest_api.codepipeline_execution.id}"
  resource_id      = "${aws_api_gateway_resource.codepipeline_execution.id}"
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = "true"
}

resource "aws_api_gateway_method_response" "codepipeline_execution_200" {
  rest_api_id = "${aws_api_gateway_rest_api.codepipeline_execution.id}"
  resource_id = "${aws_api_gateway_resource.codepipeline_execution.id}"
  http_method = "${aws_api_gateway_method.codepipeline_execution.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "codepipeline_execution" {
  rest_api_id = "${aws_api_gateway_rest_api.codepipeline_execution.id}"
  resource_id = "${aws_api_gateway_resource.codepipeline_execution.id}"
  http_method = "${aws_api_gateway_method.codepipeline_execution.http_method}"
  status_code = "${aws_api_gateway_method_response.codepipeline_execution_200.status_code}"
}

resource "aws_api_gateway_integration" "codepipeline_execution" {
  rest_api_id             = "${aws_api_gateway_rest_api.codepipeline_execution.id}"
  resource_id             = "${aws_api_gateway_resource.codepipeline_execution.id}"
  http_method             = "${aws_api_gateway_method.codepipeline_execution.http_method}"
  integration_http_method = "POST"
  type                    = "AWS"
  content_handling        = "CONVERT_TO_TEXT"
  uri                     = "${aws_lambda_function.codepipeline_execution.invoke_arn}"
}

resource "aws_api_gateway_deployment" "codepipeline_execution" {
  depends_on = [
    "aws_api_gateway_integration.codepipeline_execution",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.codepipeline_execution.id}"
  stage_name  = "codepipeline-execution-for-mycode-rip"
}

resource "aws_api_gateway_api_key" "codepipeline_execution" {
  name = "contentful-webhook-for-mycode.rip"
}

resource "aws_api_gateway_usage_plan" "codepipeline_execution" {
  name = "contentful-webhook-for-mycode.rip"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.codepipeline_execution.id}"
    stage  = "${aws_api_gateway_deployment.codepipeline_execution.stage_name}"
  }

  quota_settings {
    limit  = 30
    offset = 0
    period = "DAY"
  }
}

resource "aws_api_gateway_usage_plan_key" "codepipeline_execution" {
  key_id        = "${aws_api_gateway_api_key.codepipeline_execution.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.codepipeline_execution.id}"
}
