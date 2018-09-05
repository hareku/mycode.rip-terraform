#####################################
# Lambda Settings
#####################################
data "archive_file" "codepipeline_execution" {
  type        = "zip"
  source_dir  = "codepipeline_execution_function"
  output_path = "codepipeline_execution_function.zip"
}

resource "aws_lambda_function" "codepipeline_execution" {
  function_name    = "StartPipelineExecution"
  filename         = "${data.archive_file.codepipeline_execution.output_path}"
  source_code_hash = "${data.archive_file.codepipeline_execution.output_base64sha256}"
  role             = "${aws_iam_role.lambda_codepipeline_execution.arn}"
  handler          = "index.handler"
  runtime          = "nodejs8.10"
  timeout          = 5
  publish          = true
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.codepipeline_execution.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.codepipeline_execution.execution_arn}/POST/execute"
}
