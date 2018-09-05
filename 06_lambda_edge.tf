#####################################
# Lambda Settings
#####################################
data "archive_file" "lambda_edge_function_for_cloudfront" {
  type        = "zip"
  source_dir  = "lambda_edge_function"
  output_path = "lambda_edge_function.zip"
}

resource "aws_lambda_function" "lambda_edge_function_for_cloudfront" {
  provider         = "aws.us-east-1"
  function_name    = "CloudFrontRedirectRootObject"
  filename         = "${data.archive_file.lambda_edge_function_for_cloudfront.output_path}"
  source_code_hash = "${data.archive_file.lambda_edge_function_for_cloudfront.output_base64sha256}"
  role             = "${aws_iam_role.lambda_edge.arn}"
  handler          = "index.handler"
  runtime          = "nodejs6.10"
  timeout          = 5
  publish          = true
}
