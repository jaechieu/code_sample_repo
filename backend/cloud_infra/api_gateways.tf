# API Gateway
resource "aws_api_gateway_rest_api" "embedding_lambda_api" {
  name = "embedding_lambda_api"
}

resource "aws_api_gateway_resource" "embedding_lambda_resource" {
  path_part   = "embedding_lambda_resource"
  parent_id   = aws_api_gateway_rest_api.embedding_lambda_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.embedding_lambda_api.id
}

resource "aws_api_gateway_method" "embedding_lambda_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.embedding_lambda_api.id
  resource_id   = aws_api_gateway_resource.embedding_lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_rest_api" "data_validating_lambda_api" {
  name = "data_validating_lambda_api"
}

resource "aws_api_gateway_resource" "data_validating_lambda_resource" {
  path_part   = "data_validating_lambda_resource"
  parent_id   = aws_api_gateway_rest_api.data_validating_lambda_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.data_validating_lambda_api.id
}

resource "aws_api_gateway_method" "data_validating_lambda_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.data_validating_lambda_api.id
  resource_id   = aws_api_gateway_resource.data_validating_lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}



resource "aws_api_gateway_rest_api" "inferencing_lambda_api" {
  name = "inferencing_lambda_api"
}

resource "aws_api_gateway_resource" "inferencing_lambda_resource" {
  path_part   = "inferencing_lambda_resource"
  parent_id   = aws_api_gateway_rest_api.inferencing_lambda_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.inferencing_lambda_api.id
}

resource "aws_api_gateway_method" "inferencing_lambda_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.inferencing_lambda_api.id
  resource_id   = aws_api_gateway_resource.inferencing_lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

