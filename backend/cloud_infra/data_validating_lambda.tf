data "aws_iam_policy_document" "data_validating_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_data_validating_lambda" {
  name               = "iam_for_data_validating_lambda"
  assume_role_policy = data.aws_iam_policy_document.data_validating_assume_role.json
}

resource "null_resource" "data_validating_install_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r ${var.data_validating_lambda_path}/requirements.txt -t ${var.data_validating_lambda_path}/venv_zip && cp ${var.data_validating_lambda_path}/${var.data_validating_lambda}.py ${var.data_validating_lambda_path}/venv_zip"
  }

  triggers = {
    dependencies_versions = filemd5("${var.data_validating_lambda_path}/requirements.txt")
    source_versions       = filemd5("${var.data_validating_lambda_path}/${var.data_validating_lambda}.py")
  }
}
resource "random_uuid" "data_validating_lambda_src_hash" {
  keepers = {
    for filename in setunion(
      fileset(var.data_validating_lambda, "${var.data_validating_lambda}.py"),
      fileset(var.data_validating_lambda, "requirements.txt")
    ) :
    filename => filemd5("${var.data_validating_lambda}/${filename}")
  }
}

data "archive_file" "data_validating_lambda_source" {
  depends_on = [null_resource.data_validating_install_dependencies]
  excludes = [
    "__pycache__",
    "venv",
  ]

  source_dir  = "${var.data_validating_lambda_path}/venv_zip"
  output_path = "${random_uuid.data_validating_lambda_src_hash.result}.zip"
  type        = "zip"
}

resource "aws_lambda_function" "data_validating_lambda" {
  function_name    = "data_validating_function"
  role             = aws_iam_role.iam_for_data_validating_lambda.arn
  filename         = data.archive_file.data_validating_lambda_source.output_path
  source_code_hash = data.archive_file.data_validating_lambda_source.output_base64sha256

  handler = "${var.data_validating_lambda}.lambda_handler"
  runtime = "python3.10"

  environment {
  }
}

# # Lambda
# resource "aws_lambda_permission" "apigw_data_validating_lambda" {
#   statement_id  = "AllowExecutionFromAPIGateway"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.data_validating_lambda.function_name
#   principal     = "apigateway.amazonaws.com"

#   # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
#   source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
# }

# resource "aws_api_gateway_integration" "data_validating_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.api.id
#   resource_id             = aws_api_gateway_resource.resource.id
#   http_method             = aws_api_gateway_method.method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = aws_lambda_function.data_validating_lambda.invoke_arn
# }
