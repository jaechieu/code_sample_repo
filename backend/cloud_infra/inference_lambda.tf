data "aws_iam_policy_document" "inferencing_lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "inferencing_lambda_iam_for_lambda" {
  name               = "${var.inferencing_lambda}_iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.inferencing_lambda_assume_role.json
}

resource "null_resource" "inferencing_lambda_install_dependencies" {
  provisioner "local-exec" {
    command = "pip install -r ${var.inferencing_lambda_path}/requirements.txt -t ${var.inferencing_lambda_path}/venv_zip && cp ${var.inferencing_lambda_path}/${var.inferencing_lambda}.py ${var.inferencing_lambda_path}/venv_zip"
  }

  triggers = {
    dependencies_versions = filemd5("${var.inferencing_lambda_path}/requirements.txt")
    source_versions       = filemd5("${var.inferencing_lambda_path}/${var.inferencing_lambda}.py")
  }
}
resource "random_uuid" "inferencing_lambda_src_hash" {
  keepers = {
    for filename in setunion(
      fileset(var.inferencing_lambda, "${var.inferencing_lambda}.py"),
      fileset(var.inferencing_lambda, "requirements.txt")
    ) :
    filename => filemd5("${var.inferencing_lambda}/${filename}")
  }
}

data "archive_file" "inferencing_lambda_source" {
  depends_on = [null_resource.inferencing_lambda_install_dependencies]
  excludes = [
    "__pycache__",
    "venv",
  ]

  source_dir  = "${var.inferencing_lambda_path}/venv_zip"
  output_path = "${random_uuid.inferencing_lambda_src_hash.result}.zip"
  type        = "zip"
}

resource "aws_lambda_function" "inferencing_lambda" {
  function_name    = "${var.inferencing_lambda}_function"
  role             = aws_iam_role.inferencing_lambda_iam_for_lambda.arn
  filename         = data.archive_file.inferencing_lambda_source.output_path
  source_code_hash = data.archive_file.inferencing_lambda_source.output_base64sha256

  handler = "${var.inferencing_lambda}.lambda_handler"
  runtime = "python3.10"

  environment {
  }
}

# Lambda
resource "aws_lambda_permission" "apigw_inferencing_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.inferencing_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.inferencing_lambda_api.id}/*/${aws_api_gateway_method.inferencing_lambda_get_method.http_method}${aws_api_gateway_resource.inferencing_lambda_resource.path}"
}


resource "aws_api_gateway_integration" "inferencing_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.inferencing_lambda_api.id
  resource_id             = aws_api_gateway_resource.inferencing_lambda_resource.id
  http_method             = aws_api_gateway_method.inferencing_lambda_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.inferencing_lambda.invoke_arn
}
